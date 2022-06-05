#include <iostream>
#include <algorithm>
#include <fstream>

#include "hoptions.h"
#include "basemat.h"
#include "lapack.h"

/*
 * Double precision matrix specializations
 */

//  LU decomposition, lower part L and upper part U
//    we implement our own Crout algorithm to avoid row permutations
matrix<double> lu(const matrix<double>& A)
{
  ptrdiff_t m=A.nrows(), n=A.ncols(), i, j, ione=1;
  double pone=1, mone=-1;
  const char *chN="N";
  //  allocate output matrices
  matrix<double> B(A);  
  
  tic;
  for (j=0; j<n; j++)
  {
    //  L(i,j) = A(i,j) - L(i,k)*U(k,j)
    for (i=j; i<n; i++)
      F77_NAME(dgemm)(chN, chN, &ione, &ione, &j, &mone, &B(i,0), &n, &B(0,j), &n, &pone, &B(i,j), &n);

    //  U(j,i) = ( A(j,i) - L(j,k)*U(k,i) ) / L(j,j)
    for (i=j+1; i<n; i++)
    {
      F77_NAME(dgemm)(chN, chN, &ione, &ione, &j, &mone, &B(j,0), &n, &B(0,i), &n, &pone, &B(j,i), &n);
      B(j,i)/=B(j,j);
    }
  }
  toc("lu");
  
  return B;
}

//  side='L', op( A )*X = alpha*B
//  side='R', X*op( A ) = alpha*B
matrix<double> solve(char side, const matrix<double>& B, const mask_t& maskB, char transB, 
                                const matrix<double>& A, const mask_t& maskA, char uplo)
{
  ptrdiff_t m=maskB.nrows(), n=maskB.ncols(), ldA=A.nrows();
  double pone=1;
  const double *pA=&A(maskA.rbegin,maskA.cbegin);
  char diag=(uplo=='L') ? 'N' : 'U';
  matrix<double> X=mask(B,maskB);

  tic;
  F77_NAME(dtrsm)(&side, &uplo, &transB, &diag, &m, &n, &pone, pA, &ldA, X.val, &m);
  toc("lu");
  
  return X;
}

//  solve for x,  A*x = b
void solve(const matrix<double>& A, matrix<double>& b, mask_t maskb, char uplo)
{  
  ptrdiff_t m=A.nrows(), n=b.ncols(), ldb=b.nrows();
  double pone=1;
  char side='L', transA='N', diag=(uplo=='L') ? 'N' : 'U';
  double *pb=&b(maskb.rbegin,maskb.cbegin);
  //  solve op( A )*x = alpha*b
  F77_NAME(dtrsm)(&side, &uplo, &transA, &diag, &m, &n, &pone, A.val, &m, pb, &ldb);
}


/*
 * Complex matrix specializations
 */


//  LU decomposition, lower part L and upper part U
//    we implement our own Crout algorithm to avoid row permutations
matrix<dcmplx> lu(const matrix<dcmplx>& A)
{
  ptrdiff_t m=A.nrows(), n=A.ncols(), i, j, ione=1;
  dcmplx pone=1, mone=-1;
  const char *chN="N";
  //  allocate output matrices
  matrix<dcmplx> B(A);  
  
  tic;
  for (j=0; j<n; j++)
  {
    //  L(i,j) = A(i,j) - L(i,k)*U(k,j)
    for (i=j; i<n; i++)
      F77_NAME(zgemm)(chN, chN, &ione, &ione, &j, (const double*)&mone, (const double*)&B(i,0), &n, 
                            (const double*)&B(0,j), &n, (const double*)&pone, (double*)&B(i,j), &n);

    //  U(j,i) = ( A(j,i) - L(j,k)*U(k,i) ) / L(j,j)
    for (i=j+1; i<n; i++)
    {
      F77_NAME(zgemm)(chN, chN, &ione, &ione, &j, (const double*)&mone, (const double*)&B(j,0), &n, 
                            (const double*)&B(0,i), &n, (const double*)&pone, (double*)&B(j,i), &n);
      B(j,i)/=B(j,j);
    }
  }
  toc("lu");
  
  return B;
}

//  side='L', op( A )*X = alpha*B
//  side='R', X*op( A ) = alpha*B
matrix<dcmplx> solve(char side, const matrix<dcmplx>& B, const mask_t& maskB, char transB, 
                                const matrix<dcmplx>& A, const mask_t& maskA, char uplo)
{
  ptrdiff_t m=maskB.nrows(), n=maskB.ncols(), ldA=A.nrows();
  dcmplx pone=1;
  const double *pA=(const double*)&A(maskA.rbegin,maskA.cbegin);
  char diag=(uplo=='L') ? 'N' : 'U';
  matrix<dcmplx> X=mask(B,maskB);

  tic;
  F77_NAME(ztrsm)
    (&side, &uplo, &transB, &diag, &m, &n, (const double*)&pone, pA, &ldA, (double*)X.val, &m);
  toc("lu");
  
  return X;
}

//  solve for x,  A*x = b
void solve(const matrix<dcmplx>& A, matrix<dcmplx>& b, mask_t maskb, char uplo)
{  
  ptrdiff_t m=A.nrows(), n=b.ncols(), ldb=b.nrows();
  dcmplx pone=1;
  char side='L', transA='N', diag=(uplo=='L') ? 'N' : 'U';
  double *pb=(double*)&b(maskb.rbegin,maskb.cbegin);
  //  solve op( A )*x = alpha*b
  F77_NAME(ztrsm)
    (&side, &uplo, &transA, &diag, &m, &n, (const double*)&pone, (const double*)A.val, &m, pb, &ldb);
}
