//  submatrix.h - Sub-matrices (full or low-rank) for hierarchical matrices.
//
//  This class has to deal with both submatrices for given cluster pairs (i,j) as well as
//  submatrices that are further sub-divided, e.g. for H-matrix multiplication or inversion.
//  In case of sub-division the contents of the matrices is not modified.

/* submatrix<double> A(row,col,mat);        //  initialization with full matrix
 * submatrix<double> A(row,col,lhs,rhs);    //  initialization with Rk matrices
 * 
 * A.nrows();           //  number of rows of submatrix
 * A.ncols();           //  number of columns of submatrix
 * A.empty();           //  matrix initialized ?
 * A.name();            //  "full" or "Rk"
 * A.flag();            //  flagFull or flagRk
 * A.convert(flag);     //  convert storage format to flagFull or flagRk
 * 
 * C=A+B; C=A-B;        //  basic arithmetic operations
 * add_mul(A,x,y);      //  y = y + A*x
 * C=add(A,B);          //  summation of sub-matrices
 * A+=B;                //  add sub-matrices and compress low-rank matrices using ACA 
 * C=mul(A,B,i,j,k);    //  multiplication C(i,j) = A(i,k)*B(k,j), with i,j,k being sub-indices
 * A=cat(Amatrix,i,j);  //  concatenate matrix with sub-matrices to larger sub-matrix
 */

#include <iostream>
#include <algorithm>
#include <utility>
#include <map>
#include <string>
#include <fstream>
#include <cstdlib>

#ifndef submatrix_h
#define submatrix_h

#include "hoptions.h"
#include "basemat.h"
#include "clustertree.h"
#include "aca.h"

template<class T>
class submatrix 
{
public:
  //  either full matrix or low-rank matrix
  matrix<T> mat, lhs, rhs;
  //  row and column index of matrix
  size_t row, col;    
  
  submatrix<T>() {}
  submatrix<T>(const submatrix<T>& A) { *this=A; }
  submatrix<T>(size_t r, size_t c, const matrix<T>& A) : row(r), col(c), mat(A) {}
  submatrix<T>(size_t r, size_t c, const matrix<T>& L, const matrix<T>& R) : row(r), col(c), lhs(L), rhs(R) {}
    
  const submatrix<T>& operator= (const submatrix<T>& A)
    { mat=A.mat; lhs=A.lhs; rhs=A.rhs; row=A.row; col=A.col; return *this; }
    
  //  operations
  const submatrix<T>& operator+= (const submatrix<T>& A);
  const submatrix<T>& operator-= (const submatrix<T>& A) { return *this+=-A; }
  submatrix<T> operator- () const;  
  submatrix<T> operator+ (const submatrix<T>& A) const { return submatrix<T>(*this)+=A; }
  submatrix<T> operator- (const submatrix<T>& A) const { return submatrix<T>(*this)-=A; }
    
  //  number of rows and columns
  size_t nrows() const { pair_t siz=tree.size(row); return siz.second-siz.first; }
  size_t ncols() const { pair_t siz=tree.size(col); return siz.second-siz.first; }      
  //  size of submatrix 
  mask_t  size() const { return mask_t(0,nrows(),0,ncols()); }
  mask_t lsize() const { return mask_t(0,nrows(),0,lhs.ncols()); }
  mask_t rsize() const { return mask_t(0,ncols(),0,rhs.ncols()); }
  //  size of matrix wrt second cluster (r,c)
  mask_t  size(size_t r, size_t c) const { return mask_t(tree.size(r,row),tree.size(c,col)); }
  mask_t lsize(size_t r, size_t c) const { return mask_t(tree.size(r,row),pair_t(0,lhs.ncols())); }
  mask_t rsize(size_t r, size_t c) const { return mask_t(tree.size(c,col),pair_t(0,rhs.ncols())); }
 
  //  rank of submatrix
  size_t rank() const { ASSERT(flag()==flagRk); return lhs.ncols(); }
  //  empty submatrix ?
  bool empty() const { return mat.empty() && lhs.empty(); }
  //  "full" for full matrix, "Rk" for low-rank matrix, "" for empty matrix
  std::string name() const { return empty() ? "" : (lhs.empty() ? "full" : "Rk"); }
  //  flagFull for full matrix, flagRk for low-rank matrix, NULL for empty matrix
  short flag() const { return empty() ? 0 : (lhs.empty() ? flagFull : flagRk); }
  //  convert storage format
  const submatrix<T>& convert(short flag);
  
  //  function with same functionality as for H-matrices
  submatrix<T>* find(size_t r, size_t c) { return this; }
  const submatrix<T>* find(size_t r, size_t c) const { return this; }  
};

//  convert storage format to "Rk" or "full"
template<class T>
const submatrix<T>& submatrix<T>::convert(short cflag)
{  
  if (flag()==cflag)
    return *this;
  else if (flag()==flagRk)
    //  convert low-rank matrix to full matrix
    return *this=submatrix<T>(row,col,mul(lhs,lhs.size(),'N',rhs,rhs.size(),'T'));
  else
  {
    //  convert full matrix to low-rank matrix
    aca(mat,lhs,rhs,hopts.tol);  mat=matrix<T>();
    return *this; 
  }
}

template<class T>
submatrix<T> convert(const submatrix<T>& A, short cflag)
{
  return submatrix<T>(A).convert(cflag);
}

//  truncate low-rank matrices using aca
template<class T>
submatrix<T> truncate(submatrix<T>& A)
{
  //  truncation using aca
  if (A.flag()==flagRk) aca(A.lhs,A.rhs,hopts.tol);
    
  return A;
}

//  mask submatrix
template<class T>
submatrix<T> mask(const submatrix<T>& A, size_t r, size_t c)
{
  if (A.flag()==flagFull)
    return submatrix<T>(r,c,mask(A.mat,A.size(r,c)));
  else
    return submatrix<T>(r,c,mask(A.lhs,A.lsize(r,c)),mask(A.rhs,A.rsize(r,c)));
}

// submatrix-matrix multiplication, y = y + A*x
template<class T>
void add_mul(const submatrix<T>& A, const matrix<T>& x, matrix<T>& y)
{
  //  mask for vectors
  mask_t xmask=mask_t(tree.size(A.col),pair_t(0,x.ncols()));
  mask_t ymask=mask_t(tree.size(A.row),pair_t(0,y.ncols()));
  
  if (A.flag()==flagFull)
    //  multiplication for full matrix, y = y + A*x
    add_mul(A.mat,A.size(),'N',x,xmask,'N',y,ymask); 
  else 
  {
    //  S = transp(A.R)*x
    matrix<T> S=mul(A.rhs,A.rsize(),'T',x,xmask,'N');
    //  y = y + A.L*S
    add_mul(A.lhs,A.lsize(),'N',S,S.size(),'N',y,ymask);
  }
}

//  submatrix summation, A += B
template<class T>
const submatrix<T>& submatrix<T>::operator+= (const submatrix<T>& A)
{
  if (empty())
    *this=A;
  else if (flag()==flagFull)
    mat+=A.mat;
  else
  {
    //  concatenate low-rank matrices
    lhs=cat<T>(lhs,A.lhs);
    rhs=cat<T>(rhs,A.rhs);
    //  truncation using ACA
    truncate(*this);
  }
  
  return *this;
}

//  unary minus
template<class T>
submatrix<T> submatrix<T>::operator- () const
{ 
  if (flag()==flagFull)
    return submatrix<T>(row,col,-mat);
  else
    return submatrix<T>(row,col,-lhs,rhs);
}

//  submatrix-submatrix multiplication, C = A(i,k)*B(k,j)
template<class T>
submatrix<T> mul(const submatrix<T>& A, const submatrix<T>& B, size_t i, size_t j, size_t k)
{
  short flagA=A.flag(), flagB=B.flag();
  
  if (flagA==flagFull && flagB==flagFull)
    //  full matrices, A*B
    return submatrix<T>(i,j,mul(A.mat,A.size(i,k),'N',B.mat,B.size(k,j),'N'));
  else if (flagA==flagFull && flagB==flagRk)
    //  A*B.L, B.R
    return submatrix<T>(i,j,mul(A.mat,A.size(i,k),'N',B.lhs,B.lsize(k,j),'N'),mask(B.rhs,B.rsize(k,j)));
  else if (flagA==flagRk && flagB==flagFull)
    //  B.L, transp(A)*B.R
    return submatrix<T>(i,j,mask(A.lhs,A.lsize(i,k)),mul(B.mat,B.size(k,j),'T',A.rhs,A.rsize(i,k),'N'));  
  else
  { 
    //  S = transp(A.R)*B.L
    matrix<T> S=mul(A.rhs,A.rsize(i,k),'T',B.lhs,B.lsize(k,j),'N'); 
    
    if (S.nrows()>S.ncols())
      //  A.L*S, B.R
      return submatrix<T>(i,j,mul(A.lhs,A.lsize(i,k),'N',S,S.size(),'N'),mask(B.rhs,B.rsize(k,j))); 
    else
      // A.L, B.R*transp(S)
      return submatrix<T>(i,j,mask(A.lhs,A.lsize(i,k)),mul(B.rhs,B.rsize(k,j),'N',S,S.size(),'T'));
  }
}

//  concatenate submatrices
template<class T>
submatrix<T> cat(const matrix<submatrix<T> >& A, size_t row, size_t col)
{
  //  full matrices
  if (A(0,0).flag()==flagFull)
  {
    //  A(1,1)
    if (A.nrows()==1 && A.ncols()==1)
      return submatrix<T>(row,col,A(0,0).mat); 
    //  A(2,1)
    else if (A.nrows()==2 && A.ncols()==1)
      return submatrix<T>(row,col,cat<T>(2,1,A(0,0).mat,A(1,0).mat)); 
    //  A(1,2)
    else if (A.nrows()==1 && A.ncols()==2)
      return submatrix<T>(row,col,cat<T>(1,2,A(0,0).mat,A(0,1).mat));      
    //  A(2,2)
    else
      return submatrix<T>(row,col,cat<T>(2,2,A(0,0).mat,A(1,0).mat,A(0,1).mat,A(1,1).mat));      
  }
  else
  {
    
    #define up(a,b) a,matrix<T>(b.nrows(),a.ncols(),(T)0)
    #define lo(a,b) matrix<T>(a.nrows(),b.ncols(),(T)0),b
    
    //  A(1,1)
    if (A.nrows()==1 && A.ncols()==1)
      return submatrix<T>(row,col,A(0,0).lhs,A(0,0).rhs); 
    //  A(2,1), [ L1, 0; 0, L2 ], [ R1, R2 ]
    else if (A.nrows()==2 && A.ncols()==1)          
      return submatrix<T>(row,col,cat<T>(2,2,up(A(0,0).lhs,A(1,0).lhs),lo(A(0,0).lhs,A(1,0).lhs)),
                                  cat<T>(1,2,A(0,0).rhs,A(1,0).rhs));                            
    //  A(1,2), [ L1, L2 ], [ R1, 0; 0, R2 ]
    else if (A.nrows()==1 && A.ncols()==2)   
      return submatrix<T>(row,col,cat<T>(1,2,A(0,0).lhs,A(0,1).lhs),
                                  cat<T>(2,2,up(A(0,0).rhs,A(0,1).rhs),lo(A(0,0).rhs,A(0,1).rhs)));
    //  A(2,2), [ L11, 0, 0, L12; 0, L22, L21, 0 ], [ R11, 0, 0, R12; 0, R22, R21, 0 ]     
    else
      return submatrix<T>(row,col,
        cat<T>(2,4,up(A(0,0).lhs,A(1,0).lhs), lo(A(0,1).lhs,A(1,1).lhs), lo(A(0,0).lhs,A(1,0).lhs), up(A(0,1).lhs,A(1,1).lhs)), 
        cat<T>(2,4,up(A(0,0).rhs,A(0,1).rhs), lo(A(1,0).rhs,A(1,1).rhs), up(A(1,0).rhs,A(1,1).rhs), lo(A(0,0).rhs,A(0,1).rhs))); 
     
     #undef up
     #undef lo
  }
}

#endif  //  submatrix_h
