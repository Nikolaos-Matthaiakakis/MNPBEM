//  lu.h - LU decomposition of hierarchical matrices.

#include <iostream>
#include <algorithm>
#include <utility>
#include <stdexcept>
#include <map>
#include <string>
#include <fstream>
#include <cstdlib>

#ifndef lu_h
#define lu_h

#include "hoptions.h"
#include "clustertree.h"
#include "basemat.h"
#include "submatrix.h"
#include "hmatrix.h"

//  LU decomposition
matrix<double> lu(const matrix<double>&);
matrix<dcmplx> lu(const matrix<dcmplx>&);

matrix<double> solve(char, const matrix<double>&, const mask_t&, char,
                           const matrix<double>&, const mask_t&, char);
matrix<dcmplx> solve(char, const matrix<dcmplx>&, const mask_t&, char,
                           const matrix<dcmplx>&, const mask_t&, char);

void solve(const matrix<double>&, matrix<double>&, mask_t, char);
void solve(const matrix<dcmplx>&, matrix<dcmplx>&, mask_t, char);

/*
 * LU decomposition for sub-matrices
 */

//  solve for X, X*A = B
template<class T>
submatrix<T> rsolve(const submatrix<T>& B, const submatrix<T>& A, size_t i, size_t j, char uplo)
{
  if (B.flag()==flagFull)
    return submatrix<T>(i,j,solve('R',B.mat,B.size(i,j),'N',A.mat,A.size(),uplo));
  else if (B.flag()==flagRk)
  {
    matrix<T> lhs=mask(B.lhs,B.lsize(i,j));
    matrix<T> rhs=solve('L',B.rhs,B.rsize(i,j),'T',A.mat,A.size(),uplo);
    
    return submatrix<T>(i,j,lhs,rhs);
  }
}

//  solve for X, A*X = B
template<class T>
submatrix<T> lsolve(const submatrix<T>& B, const submatrix<T>& A, size_t i, size_t j, char uplo)
{ 
  if (B.flag()==flagFull)
    return submatrix<T>(i,j,solve('L',B.mat,B.size(i,j),'N',A.mat,A.size(),uplo));
  else if (B.flag()==flagRk)
  {
    matrix<T> lhs=solve('L',B.lhs,B.lsize(i,j),'N',A.mat,A.size(),uplo);
    matrix<T> rhs=mask(B.rhs,B.rsize(i,j));
    
    return submatrix<T>(i,j,lhs,rhs);
  }
}

/*
 * LU decomposition for H-matrices
 */

//  solve for submatrix X,  X(i,j)*A(j,j) = B(i,j)
template<class T>
submatrix<T> rsolve(const submatrix<T>& B, const hmatrix<T>& A, size_t i, size_t j, char uplo)
{
  if (tree.admiss(j,j))
    return rsolve(B,*A.find(j,j),i,j,uplo);
  else
  {
    matrix<submatrix<T> > X(1,2);
    //  subdivide cluster
    size_t first=uplo=='U' ? 0 : 1, second=uplo=='U' ? 1 : 0;
    size_t j0=tree.sons(j,first), j1=tree.sons(j,second);
    
    //  X00*U00 = B00,  X01*L11 = B01
    X[first]=rsolve(B,A,i,j0,uplo);
    //  X01*U11 = B01 - X00*U01,  X00*L00 = B00 - X01*L10
    X[second]=rsolve(mask(B,i,j1)-add_mul2<T>(X[first],A,i,j1,j0,B.flag()),A,i,j1,uplo);
    
    //  assemble matrix
    submatrix<T> x=cat(X,i,j); 
    return truncate(x);
  }
}  

//  solve for submatrix X,  A(i,i)*X(i,j) = B(i,j)
template<class T>
submatrix<T> lsolve(const submatrix<T>& B, const hmatrix<T>& A, size_t i, size_t j, char uplo)
{ 
  if (tree.admiss(i,i))
    return lsolve(B,*A.find(i,i),i,j,uplo);
  else
  {
    matrix<submatrix<T> > X(2,1);
    //  subdivide cluster
    size_t first=uplo=='L' ? 0 : 1, second=uplo=='L' ? 1 : 0;
    size_t i0=tree.sons(i,first), i1=tree.sons(i,second);
    
    //  L00*X00 = B00,  U11*X10 = B10
    X[first]=lsolve(B,A,i0,j,uplo);
    //  L11*X10 = B10 - L10*X00,  U00*X00 = B00 - U01*X10
    X[second]=lsolve(mask(B,i1,j)-add_mul2<T>(A,X[first],i1,j,i0,B.flag()),A,i1,j,uplo);
    
    //  assemble matrix
    submatrix<T> x=cat(X,i,j);
    return truncate(x);
  }
}  

#define sub_mul(A,B,C,i,j,k) subtract(A,mul(B,C,i,j,k),i,j)

//  solve X*op( A ) = B
template<class T>
void rsolve(const hmatrix<T>& B, const hmatrix<T>& A, hmatrix<T>& X, size_t i, size_t j, char uplo)
{ 
  const submatrix<T> *pA=A.find(j,j), *pB=B.find(i,j);
  
  if (pA && pB)
    //  X(sub)*A(sub)
    X[pair_t(i,j)]=rsolve(*pB,*pA,i,j,uplo);
  else if (pA && !pB)
    //  X(H)*A(sub)
    for (treeiterator ii=tree.begin(i); ii!=tree.end(); ii++) rsolve(B,A,X,*ii,j,uplo);
  else if (!pA && !pB)
    //  subdivide matrices
    //    Xi0*U00 = Ai0,            Xi1*L11 = Bi1
    //    Xi1*U11 = Ai1 - Xi0*U01,  Xi0*L00 = Bi0 - Xi1*L10
    for (treeiterator jj=uplo=='U' ? tree.begin(j) : tree.begin(j).reverse(); jj!=tree.end(); jj++)  
    for (treeiterator ii=tree.begin(i); ii!=tree.end(); ii++)
      rsolve(jj.num ? sub_mul(B,X,A,*ii,*jj,tree.sons(j,uplo=='U' ? 0 : 1)) : B,A,X,*ii,*jj,uplo);
  
  else
    //  subdivide U matrix
    X[pair_t(i,j)]=rsolve(*pB,A,i,j,uplo);
}

//  solve op( A )*X = B
template<class T>
void lsolve(const hmatrix<T>& B, const hmatrix<T>& A, hmatrix<T>& X, size_t i, size_t j, char uplo)
{
  //  are matrices of type submatrix ?
  const submatrix<T> *pA=A.find(i,i), *pB=B.find(i,j);
    
  if (pA && pB)
    //  A(sub)*X(sub)
    X[pair_t(i,j)]=lsolve(*pB,*pA,i,j,uplo);
  else if (pA && !pB)
    //  A(sub)*X(H)
    for (treeiterator jj=tree.begin(j); jj!=tree.end(); jj++) lsolve(B,A,X,i,*jj,uplo);
  else if (!pA && !pB)
    //  subdivide matrices
    //    L00*X0j = B0j,            U11*X1j = B1j
    //    L11*X1j = B1j - L10*X0j,  U00*X0j = B0j - U01*X1j
    for (treeiterator ii=uplo=='L' ? tree.begin(i) : tree.begin(i).reverse(); ii!=tree.end(); ii++)
    for (treeiterator jj=tree.begin(j); jj!=tree.end(); jj++) 
      lsolve(ii.num ? sub_mul(B,A,X,*ii,*jj,tree.sons(i,uplo=='L' ? 0 : 1)) : B,A,X,*ii,*jj,uplo);
 
  else
    //  subdivide A matrix
    X[pair_t(i,j)]=lsolve(*pB,A,i,j,uplo);
}

#undef sub_mul

//  LU-decomposition of H-matrix
template<class T>
void lu(const hmatrix<T>& B, hmatrix<T>& A, size_t i=0)
{
  //  sons of cluster
  size_t i0=tree.sons(i,0), i1=tree.sons(i,1);
 
  //  full matrix ?
  if (i0==0 && i1==0)
    A[pair_t(i,i)]=submatrix<T>(i,i,lu(B.find(i,i)->mat));
  else
  {
    //  L00*U00 = B00
    lu(B,A,i0);
    //  L00*U01 = B01
    lsolve(B,A,A,i0,i1,'L');
    //  L10*U00 = B10
    rsolve(B,A,A,i1,i0,'U');
    //  L11*U11 = B11 - L10*U01
    lu(subtract(B,mul(A,A,i1,i1,i0),i1,i1),A,i1);
  }
}

/*
 * Solve system of linear equations using L and U matrices
 */

//  solve A*x = b, override b
template<class T>
void solve(const hmatrix<T>& A, matrix<T>& b, size_t i, char uplo)
{
  if (tree.admiss(i,i))
    solve(A.find(i,i)->mat,b,mask_t(tree.size(i),pair_t(0,b.ncols())),uplo);
  else
  { 
    //  subdivide matrix
    size_t i0=(uplo=='L') ? tree.sons(i,0) : tree.sons(i,1);
    size_t i1=(uplo=='L') ? tree.sons(i,1) : tree.sons(i,0);
    
    //  A00*x0 = b0
    solve(A,b,i0,uplo);
    //  A11*y1 = b1 - A10*y0
    //    start at cluster pair (i1,i0) and move down the tree
    for (pairiterator it=tree.pair_begin(i1,i0); it!=tree.pair_end(); it++) 
      add_mul(-*A.find(it->first,it->second),b,b);
    solve(A,b,i1,uplo);
  }  
}
        
#endif  //  lu_h
