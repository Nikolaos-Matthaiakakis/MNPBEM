//  basemat.cpp - Specializations of basemat.h.

#include <iostream>
#include <algorithm>
#include <fstream>

#include "hoptions.h"
#include "basemat.h"
#include "lapack.h"

  
/*
 * Double precision matrix specializations
 */

//  output of mask
std::ostream& operator<< (std::ostream& os, const mask_t& mask)
{
  return os << mask.rbegin << " " << mask.rend << " " << mask.cbegin << " " << mask.cend;
}

//  copy array to matrix
template<> 
const matrix<double>& matrix<double>::copy(const double* t)
{
  ptrdiff_t n=mld*nld, ione=1;
  //  copy array using BLAS routine
  tic;
  F77_NAME(dcopy)(&n, t, &ione, val, &ione);
  toc("dcopy");
  
  return *this;
} 

//  add matrices
template<> 
const matrix<double>& matrix<double>::add_to(const matrix<double>& mat, const double& a)
{
  ptrdiff_t n=mld*nld, ione=1;
  //  add matrices using BLAS routine
  tic;
  F77_NAME(daxpy)(&n, &a, mat.val, &ione, val, &ione);
  toc("add");
  
  return *this;
}  

//  scale matrix with constant value
template<> 
const matrix<double>& matrix<double>::scale(const double& a)
{
  ptrdiff_t n=mld*nld, ione=1;
  //  scale matrix using BLAS routine
  F77_NAME(dscal)(&n, &a, val, &ione);
  
  return *this;
}

//  concatenate matrices horizontally
template<> 
matrix<double> cat(const matrix<double>& A, const matrix<double>& B)
{
  ptrdiff_t nA=A.nrows()*A.ncols(), nB=B.nrows()*B.ncols(), ione=1;
  
  ASSERT(A.nrows()==B.nrows());
  //  allocate output matrix
  matrix<double> C(A.nrows(),A.ncols()+B.ncols());
  
  //  copy arrays using BLAS routine
  tic;
  F77_NAME(dcopy)(&nA, A.begin(), &ione, C.begin(),    &ione);
  F77_NAME(dcopy)(&nB, B.begin(), &ione, C.begin()+nA, &ione);
  toc("dcopy");
  
  return C;
}
 
//  multiply matrices using the BLAS library, C = C + op( A )*op( B )  
template<>
void add_mul(const matrix<double>& A, const mask_t& maskA, char transA,
             const matrix<double>& B, const mask_t& maskB, char transB,
                   matrix<double>& C, const mask_t& maskC)
{
  //  variables for BLAS routine dgemm, C := alpha*op( A )*op( B ) + beta*C
  ptrdiff_t mA=maskA.nrows(), nA=maskA.ncols(),  
            mB=maskB.nrows(), nB=maskB.ncols(), m, n, k;
  ptrdiff_t ldA=A.nrows(), ldB=B.nrows(), ldC=C.nrows();
  double alpha=1, beta=1;
  //  pointer to first elements of matrices
  const double *pA=&A(maskA.rbegin,maskA.cbegin), *pB=&B(maskB.rbegin,maskB.cbegin);
  double *pC=&C(maskC.rbegin,maskC.cbegin);
  
       if (transA=='N' && transB=='N') m=mA, k=nA, n=nB;
  else if (transA=='T' && transB=='N') m=nA, k=mA, n=nB;
  else if (transA=='N' && transB=='T') m=mA, k=nA, n=mB;
  else if (transA=='T' && transB=='T') m=nA, k=mA, n=mB; 
  
  //  call BLAS routine 
  tic; 
  F77_NAME(dgemm)(&transA, &transB, &m, &n, &k, &alpha, pA, &ldA, pB, &ldB, &beta, pC, &ldC);
  toc("mul_BLAS");
}

//  matrix inversion
matrix<double> inv(const matrix<double>& A)
{
  //  number of rows and columns
  ptrdiff_t m=A.nrows(), n=A.ncols(), info, lwork=n*n;
  matrix<double> Ai(A), work(n,n);
  matrix<ptrdiff_t> ipiv(m,1);
  
  tic;
  //  LU factorization
  F77_NAME(dgetrf)(&n, &n, Ai.val, &n, ipiv.val, &info);
  //  matrix inversion
  F77_NAME(dgetri)(&n, Ai.val, &n, ipiv.val, work.val, &lwork, &info);
  toc("inv_LAPACK");
  
  ASSERT(!info);
  return Ai;
}

#ifdef MEX
//  copy C++ matrix into Matlab array
mxArray* setmex(const matrix<double>& mat)
{
  mxArray* lhs=mxCreateNumericMatrix(mat.nrows(),mat.ncols(),mxDOUBLE_CLASS,mxREAL);
  std::copy(mat.begin(),mat.end(),(double*)mxGetPr(lhs));
  
  return lhs;
}
#endif  //  MEX


/*
 * Complex matrix specializations
 */


//  copy array to matrix
template<> 
const matrix<dcmplx>& matrix<dcmplx>::copy(const dcmplx* t)
{
  ptrdiff_t n=mld*nld, ione=1;
  //  copy array using BLAS routine
  tic;
  F77_NAME(zcopy)(&n, (const double *)t, &ione, (double *)val, &ione);
  toc("dcopy");
  
  return *this;
} 

//  add matrices
template<> 
const matrix<dcmplx>& matrix<dcmplx>::add_to(const matrix<dcmplx>& mat, const dcmplx& a)
{
  ptrdiff_t n=mld*nld, ione=1;
  //  add matrices using BLAS routine
  tic;
  F77_NAME(zaxpy)(&n, (const double*)&a, (const double*)mat.val, &ione, (double*)val, &ione);
  toc("add");
  
  return *this;
}  

//  scale matrix with constant value
template<> 
const matrix<dcmplx>& matrix<dcmplx>::scale(const dcmplx& a)
{
  ptrdiff_t n=mld*nld, ione=1;
  //  scale matrix using BLAS routine
  F77_NAME(zscal)(&n, (const double*)&a, (double*)val, &ione);
  
  return *this;
}

//  concatenate matrices horizontally
template<> 
matrix<dcmplx> cat(const matrix<dcmplx>& A, const matrix<dcmplx>& B)
{
  ptrdiff_t nA=A.nrows()*A.ncols(), nB=B.nrows()*B.ncols(), ione=1;
  
  ASSERT(A.nrows()==B.nrows());
  //  allocate output matrix
  matrix<dcmplx> C(A.nrows(),A.ncols()+B.ncols());
  
  //  copy arrays using BLAS routine
  tic;
  F77_NAME(zcopy)(&nA, (const double*)A.begin(), &ione, (double*) C.begin(),     &ione);
  F77_NAME(zcopy)(&nB, (const double*)B.begin(), &ione, (double*)(C.begin()+nA), &ione);
  toc("dcopy");
  
  return C;
}

//  multiply matrices using the BLAS library, C = C + op( A )*op( B )  
template<>
void add_mul(const matrix<dcmplx>& A, const mask_t& maskA, char transA,
             const matrix<dcmplx>& B, const mask_t& maskB, char transB,
                   matrix<dcmplx>& C, const mask_t& maskC)
{
  //  variables for BLAS routine zgemm, C := alpha*op( A )*op( B ) + beta*C
  ptrdiff_t mA=maskA.nrows(), nA=maskA.ncols(), 
            mB=maskB.nrows(), nB=maskB.ncols(), m, n, k;
  ptrdiff_t ldA=A.nrows(), ldB=B.nrows(), ldC=C.nrows();
  dcmplx alpha=1, beta=1;
  //  pointer to first elements of matrices
  const double *pA=(const double*)&A(maskA.rbegin,maskA.cbegin), 
               *pB=(const double*)&B(maskB.rbegin,maskB.cbegin);
  double *pC=(double*)&C(maskC.rbegin,maskC.cbegin);
  
       if (transA=='N' && transB=='N') m=mA, k=nA, n=nB;
  else if (transA=='T' && transB=='N') m=nA, k=mA, n=nB;
  else if (transA=='N' && transB=='T') m=mA, k=nA, n=mB;
  else if (transA=='T' && transB=='T') m=nA, k=mA, n=mB; 
  
  //  call BLAS routine 
  tic; 
  F77_NAME(zgemm)(&transA, &transB, &m, &n, &k, (const double*)&alpha, pA, &ldA, pB, &ldB, 
                                                (const double*)&beta,  pC, &ldC);
  toc("mul_BLAS");
}

//  matrix inversion
matrix<dcmplx> inv(const matrix<dcmplx>& A)
{
  //  number of rows and columns
  ptrdiff_t m=A.nrows(), n=A.ncols(), info, lwork=n*n;
  matrix<dcmplx> Ai(A), work(n,n);
  matrix<ptrdiff_t> ipiv(m,1);
  
  tic;
  //  LU factorization
  F77_NAME(zgetrf)(&n, &n, (double*)Ai.val, &n, ipiv.val, &info);
  //  matrix inversion
  F77_NAME(zgetri)(&n, (double*)Ai.val, &n, ipiv.val, (double*)work.val, &lwork, &info);
  toc("inv_LAPACK");
  
  ASSERT(!info);
  return Ai;
}

#ifdef MEX
template<>
matrix<dcmplx> matrix<dcmplx>::getmex(const mxArray* rhs)
{
  matrix<dcmplx> mat(mxGetM(rhs),mxGetN(rhs));
  ptrdiff_t n=mat.nrows()*mat.ncols(), ione=1, itwo=2;
  //  copy real and imaginary parts
                        F77_NAME(dcopy)(&n, mxGetPr(rhs), &ione, (double*)mat.val,   &itwo);
  if (mxIsComplex(rhs)) F77_NAME(dcopy)(&n, mxGetPi(rhs), &ione, (double*)mat.val+1, &itwo);

  //  return matrix
  return mat;
}

//  copy C++ matrix into Matlab array
mxArray* setmex(const matrix<dcmplx>& mat)
{
  ptrdiff_t m=mat.nrows(), n=mat.ncols(), siz=m*n, ione=1, itwo=2;
  mxArray* x=mxCreateDoubleMatrix(m,n,mxCOMPLEX);
  
  //  copy real and imaginary part
  F77_NAME(dcopy)(&siz, (const double*)mat.val,   &itwo, mxGetPr(x), &ione);
  F77_NAME(dcopy)(&siz, (const double*)mat.val+1, &itwo, mxGetPi(x), &ione); 
    
  return x;
}
#endif // MEX