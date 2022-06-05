//  hmatrix.h - hierarchical matrices.
//
//  We provide a class with basic functionality for H-matrices.

/* hmatrix<double> A;                   //  initialize empty H-matrix
 * A=hmatrix<double>::getmex(prhs);     //  convert Matlab H-matrix to C++
 * setmex(A,plhs);                      //  copy C++ matrices to Matlab
 * A.fread(fid);                        //  read H-matrix from file
 * 
 * for (hmatrix<double>::iterator it=A.begin(); it!=A.end(); it++) *it;
 *                        //  loop over H-matrices (works also for const_iterator)
 * A.find(i,j);           //  find cluster pair (i,j), zero if pair not initialized
 * y=A*x;                 //  multiply H-matrix with matrix or vector
 * A+=B; A+B; A-=B; A-B;  //  H-matrix summation or subtraction
 * A*B;                   //  H-matrix multiplication
 * C=mul(A,B,i,j,k);      //  C(i,j)=A(i,k)*B(k,j)
 * inv(A);                //  invert H-matrix
 */

#include <iostream>
#include <algorithm>
#include <utility>
#include <stdexcept>
#include <map>
#include <string>
#include <fstream>
#include <cstdlib>

#ifndef hmatrix_h
#define hmatrix_h

#include "hoptions.h"
#include "clustertree.h"
#include "basemat.h"
#include "submatrix.h"

template<class T>
class hmatrix
{
public:  
  typedef typename std::map<pair_t,submatrix<T> >::iterator iterator;
  typedef typename std::map<pair_t,submatrix<T> >::const_iterator const_iterator;
  
  std::map<pair_t,submatrix<T> > mat;
  
  //  constructors
  hmatrix<T>() {}
  hmatrix<T>(const hmatrix<T>& A) : mat(A.mat) {}
  //  assignement operator
  const hmatrix<T>& operator= (const hmatrix<T>& A) { mat=A.mat; return *this; }
    
  //  summation and subtraction of H-matrices
  const hmatrix<T>& operator+= (const hmatrix<T>&);
  const hmatrix<T>& operator-= (const hmatrix<T>& A) { *this+=-A; }
  //  unary minus
  hmatrix<T> operator- () const;
  //  multiplication with matrix of H-matrix
   matrix<T> operator* (const  matrix<T>&) const;
  hmatrix<T> operator* (const hmatrix<T>&) const;
    
  //  find entry
  submatrix<T>* find(size_t row, size_t col) 
    { iterator it=mat.find(pair_t(row,col));  return (it!=mat.end()) ? &it->second : 0; } 
  const submatrix<T>* find(size_t row, size_t col)  const
    { const_iterator it=mat.find(pair_t(row,col));  return (it!=mat.end()) ? &it->second : 0; }
     
  //  reference operator
  submatrix<T>& operator[] (const pair_t& it) { return mat[it]; }   
  const submatrix<T>& operator[] (const pair_t& it) const { return mat[it]; }   
  //  map functions
  iterator begin() { return mat.begin(); }
  const_iterator begin() const { return mat.begin(); }
  iterator end() { return mat.end(); }
  const_iterator end() const { return mat.end(); }  
  
  //  clear H-matrix
  void clear() { mat.clear(); }   
  //  read matrix from file or write matrix to file
  void fread(FILE* fid);
  FILE* fwrite(FILE* fid) const;   
  //  convert Matlab arrays to H-matrix
  #ifdef MEX
  static hmatrix<T> getmex(const mxArray* prhs[]);
  #endif // MEX
};

//  convert H-matrix to full matrix (for testing)
template<class T>
matrix<T> full(const hmatrix<T>& A)
{  
  typedef typename std::map<pair_t,submatrix<T> >::const_iterator const_iterator;
  const std::map<pair_t,submatrix<T> >& mat=A.mat;
  //  allocate full matrix
  matrix<T> B(tree.ind(0,1),tree.ind(0,1));

  //  loop over submatrices
  for (const_iterator it=mat.begin(); it!=mat.end(); it++)
  {
    //  expand sub-matrix to full size
    matrix<T> sub=convert(it->second,flagFull).mat;
    //  copy to full matrix
    copy(sub,sub.size(),B,mask_t(tree.size(it->first.first),tree.size(it->first.second)));
  }
  return B;
}

//  multiplication with matrix, y = A*x
template<class T>
matrix<T> hmatrix<T>::operator* (const matrix<T>& x) const
{
  matrix<T> y=matrix<T>(x.nrows(),x.ncols(),(T)0);
      
  //  loop over all sub-matrices and perform submatrix-vector multiplication
  for (const_iterator it=mat.begin(); it!=mat.end(); it++) add_mul(it->second,x,y);
  return y;
}

//  copy submatrices using tree
template<class T>
hmatrix<T> copy(const hmatrix<T>& A, size_t i=0, size_t j=0)
{
  hmatrix<T> B;
  //  start at cluster pair (i,j) and move down the tree
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++) 
    B[*it]=*A.find(it->first,it->second);
  
  return B;
}

/*
 * Summation and subtraction of H-matrices 
 */

//  unary minus using tree, -A(H)
template<class T>
hmatrix<T> uminus(const hmatrix<T>& A, size_t i=0, size_t j=0)
{
  hmatrix<T> B;
  //  start at cluster pair (i,j) and move down the tree
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++) 
    B[*it]=-*A.find(it->first,it->second);
  
  return B;
}

//  unary minus
template<class T>
hmatrix<T> hmatrix<T>::operator- () const
{
  return uminus(*this);
}

//  add two H-matrices using tree, C(H) += A(H) + B(H)
template<class T>
void add(const hmatrix<T>& A, const hmatrix<T>& B, hmatrix<T>& C, size_t i=0, size_t j=0)
{
  //  start at cluster pair (i,j) and move down the tree
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++) 
    C[*it]+=*A.find(it->first,it->second)+*B.find(it->first,it->second);
}

//  add two H-matrices using tree, A(H) + B(H)
template<class T>
hmatrix<T> add(const hmatrix<T>& A, const hmatrix<T>& B, size_t i=0, size_t j=0)
{
  hmatrix<T> C;
  //  start at cluster pair (i,j) and move down the tree
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++) 
    C[*it]=*A.find(it->first,it->second)+*B.find(it->first,it->second);
  
  return C;
}

//  A(H) += B(H)
template<class T>
const hmatrix<T>& hmatrix<T>::operator+= (const hmatrix<T>& A)
{
  return *this=add(*this,A);
}

//  A(H) + B(H)
template<class T>
hmatrix<T> operator+ (const hmatrix<T>& A, const hmatrix<T>& B)
{
  return add(A,B);
}

//  subtract two H-matrices using tree, A(H) - B(H)
template<class T>
hmatrix<T> subtract(const hmatrix<T>& A, const hmatrix<T>& B, size_t i, size_t j)
{
  hmatrix<T> C;
  //  start at cluster pair (i,j) and move down the tree
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++) 
    C[*it]=*A.find(it->first,it->second)-*B.find(it->first,it->second);
  
  return C;  
}

//  A(H) - B(H)
template<class T>
hmatrix<T> operator- (const hmatrix<T>& A, const hmatrix<T>& B)
{
  return subtract(A,B);
}

/*
 * Multiplication of H-matrices 
 */

//  recursive function for H-matrix multiplication, C(sub) = A(sub,H)*B(sub,H)
template<class T, class Amat, class Bmat>
submatrix<T> add_mul2(const Amat& A, const Bmat& B, size_t i, size_t j, size_t k, short flag)
{
  //  are matrices of type submatrix ?
  const submatrix<T> *pA=A.find(i,k), *pB=B.find(k,j);
  
  if (pA && pB)
    return mul(*pA,*pB,i,j,k).convert(flag);
  else
  {
    //  subdivide matrices
    treeiterator ii=tree.begin(i), jj=tree.begin(j), kk;
    matrix<submatrix<T> > C(ii->size(),jj->size());
    
    //  matrix multiplication with subdivided matrices
    for (ii=tree.begin(i); ii!=tree.end(); ii++)
    for (jj=tree.begin(j); jj!=tree.end(); jj++)
    for (kk=tree.begin(k); kk!=tree.end(); kk++)
      if (pA)
        //  A(sub)*B(H)
        C(ii->num,jj->num)+=add_mul2<T>(*pA,B,*ii,*jj,*kk,flag); 
      else if (pB)
        //  A(H)*B(sub)
        C(ii->num,jj->num)+=add_mul2<T>(A,*pB,*ii,*jj,*kk,flag);
      else
        //  A(H)*B(H)
        C(ii->num,jj->num)+=add_mul2<T>(A,B,*ii,*jj,*kk,flag);
        
    //  assemble matrix
    return cat(C,i,j);    
  }  
}

//  recursive function for H-matrix multiplication, C(H) = A(sub,H)*B(sub,H)
template<class T, class Amat, class Bmat>
void add_mul(const Amat& A, const Bmat& B, hmatrix<T>& C, size_t i, size_t j, size_t k)
{
  //  are matrices of type submatrix ?
  const submatrix<T> *pA=A.find(i,k), *pB=B.find(k,j);
  //  admissibility of C matrix
  short adC=tree.admiss(i,j);
  
  if (adC==0)
    //  all matrices are subdivided
    for (treeiterator ii=tree.begin(i); ii!=tree.end(); ii++)
    for (treeiterator jj=tree.begin(j); jj!=tree.end(); jj++)
    for (treeiterator kk=tree.begin(k); kk!=tree.end(); kk++)       
    {
      if (pA==0 && pB==0) 
        //  C(H) = A(H)*B(H)
        add_mul(A,B,C,*ii,*jj,*kk);
      else if (pA!=0 && pB==0)
        //  C(H) = A(sub)*B(H)
        add_mul(*pA,B,C,*ii,*jj,*kk);
      else if (pA==0 && pB!=0)
        //  C(H) = A(H)*B(sub)
        add_mul(A,*pB,C,*ii,*jj,*kk);
      else
        //  C(H) = A(sub)*B(sub)
        add_mul(*pA,*pB,C,*ii,*jj,*kk);        
    }
  else if (adC!=0 && pA!=0 && pB!=0)
    //  C(sub) = A(sub)*B(sub)
    C.mat[pair_t(i,j)]+=mul(*pA,*pB,i,j,k).convert(adC);
  else
    //  C(sub) = A(H)*B(H)
    C.mat[pair_t(i,j)]+=add_mul2<T>(A,B,i,j,k,adC);
}

//  multiply two H-matrices using tree, C(i,j) = A(i,k) * B(k,j)
template<class T>
hmatrix<T> mul(const hmatrix<T>& A, const hmatrix<T>& B, size_t i=0, size_t j=0, size_t k=0)
{
  hmatrix<T> C;
  
  add_mul(A,B,C,i,j,k);
  return C;
}

//  multiplication of two H-matrices A * B
template<class T>
hmatrix<T> hmatrix<T>::operator* (const hmatrix<T>& B) const
{
  //  return matrix
  hmatrix<T> C;
  //  recursive H-matrix multiplication
  add_mul(*this,B,C,0,0,0);
  
  return C;
}

/*
 * H-matrix inversion
 */

//  recursive inversion of H-matrix
template<class T>
hmatrix<T> inv(const hmatrix<T>& A, size_t i=0)
{
  //  return matrix
  hmatrix<T> C;
  //  sons of cluster
  size_t i0=tree.sons(i,0), i1=tree.sons(i,1);
 
  //  full matrix ?
  if (i0==0 && i1==0)
  {
    //  get submatrix pointer
    const submatrix<T>* it=A.find(i,i);
    //  calculate the inverse exactly
    C[pair_t(i,i)]=submatrix<T>(i,i,inv(it->mat));
  }
  else
  {
    //  working matrices 
    hmatrix<T> Y,S,t;
    //  Schur decomposition of subdivided matrix, Y = inv(A00)
    Y=inv(A,i0); 
    //  S = A11 - A10 * Y * A01
    S=subtract(A,mul(A,mul(Y,A,i0,i1,i0),i1,i1,i0),i1,i1); 
    //  invert S,  C11 = inv(S)
    C=inv(S,i1); 

    //  C00 = Y + Y * A01 * C11 * A10 * Y
    t=mul(Y,mul(A,mul(C,mul(A,Y,i1,i0,i0),i1,i0,i1),i0,i0,i1),i0,i0,i0);
    add(Y,t,C,i0,i0);
    //  C01 = - Y * A01 * C11
    add_mul(uminus(Y,i0,i0),mul(A,C,i0,i1,i1),C,i0,i1,i0); 
    //  C10 = - C11 * A10 * Y
    add_mul(C,mul(A,uminus(Y,i0,i0),i1,i0,i0),C,i1,i0,i1); 
  }  
  
  return C;
}

/*
 * Read H-matrix from file or from MEX input
 */

//  read matrix from file
template<class T>
void hmatrix<T>::fread(FILE* fid)
{
  matrix<size_t> rc;    

  //  rows and columns of full matrices
  rc=matrix<size_t>::fread(fid); 
  //  read full matrices
  for (size_t i=0; i<rc.nrows(); i++)
  {
    size_t row=rc(i,0), col=rc(i,1);
    matrix<T> A=matrix<T>::fread(fid);
    
    mat[pair_t(row,col)]=submatrix<T>(row,col,A);
    //  set admissibility 
    tree.ad[pair_t(row,col)]=2;
  }
  
  //  rows and columns of low-rank matrices
  rc=matrix<size_t>::fread(fid);
  //  read low-rank matrices
  for (size_t i=0; i<rc.nrows(); i++)
  {
    size_t row=rc(i,0), col=rc(i,1);
    
    matrix<T> L=matrix<T>::fread(fid);
    matrix<T> R=matrix<T>::fread(fid);
    
    mat[pair_t(row,col)]=submatrix<T>(row,col,L,R);
    //  set admissibility 
    tree.ad[pair_t(row,col)]=1;   
  }  
}

#ifdef MEX
//  convert Matlab arrays to H-matrix
template<class T>
hmatrix<T> hmatrix<T>::getmex(const mxArray* prhs[])
{
  const mxArray *A=prhs[0], *L=prhs[1], *R=prhs[2];
  //  return matrix
  hmatrix<T> H;
  
  //  loop over full matrices
  for (size_t i=0; i<ind1.nrows(); i++)
  {
    //  rows and columns
    size_t row=ind1(i,0), col=ind1(i,1);
    
    H.mat[pair_t(row,col)]=
            submatrix<T>(row,col,matrix<T>::getmex(mxGetCell(A,i)));
  }
  
  //  loop over low-rank matrices
  for (size_t i=0; i<ind2.nrows(); i++)
  {
    //  rows and columns
    size_t row=ind2(i,0), col=ind2(i,1);
    
    H.mat[pair_t(row,col)]=
            submatrix<T>(row,col,matrix<T>::getmex(mxGetCell(L,i)),
                                 matrix<T>::getmex(mxGetCell(R,i)));
  }  
  //  return H-matrix
  return H;
}

//  copy H-matrix to Matlab arrays
template<class T>
void setmex(const hmatrix<T>& H, mxArray* plhs[])
{
  const submatrix<T> *p;
  
  //  create cell arrays for full and low-rank matrices
  plhs[0]=mxCreateCellMatrix((mwSize)ind1.nrows(),1);
  plhs[1]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);
  plhs[2]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);
  
  //  loop over full matrices
  for (size_t i=0; i<ind1.nrows(); i++)
  {
    p=H.find(ind1(i,0),ind1(i,1));
    if (p) mxSetCell(plhs[0],i,setmex(p->mat));
  }
  
  //  loop over low-rank matrices
  for (size_t i=0; i<ind2.nrows(); i++)
  {
    p=H.find(ind2(i,0),ind2(i,1));
    if (p) mxSetCell(plhs[1],i,setmex(p->lhs));
    if (p) mxSetCell(plhs[2],i,setmex(p->rhs));
  }        
}
#endif  //  MEX
#endif  //  hmatrix_h
