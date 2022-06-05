#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>

#include "hoptions.h"
#include "aca.h"

/*
 * Double precision ACA
 */

//  get row for full matrix
template<> 
void acafull<double>::getrow(size_t r, double* b) const
{
  ptrdiff_t m=nrows(), n=ncols(), row=r, ione=1;
  //  get row
  F77_NAME(dcopy)(&n, mat.val+row, &m, b, &ione);
}

//  get column for full matrix
template<> 
void acafull<double>::getcol(size_t c, double* a) const
{
  ptrdiff_t m=nrows(), n=ncols(), col=c, ione=1;
  //  get column
  F77_NAME(dcopy)(&m, mat.val+col*m, &ione, a, &ione);
}

//  get row for low-rank matrix
template<> 
void acaRk<double>::getrow(size_t r, double *b) const
{
  ptrdiff_t m=nrows(), n=ncols(), kmax=max_rank(), row=r, ione=1;
  const char *chN="N", *chT="T";
  double one=1., zero=0.;
  //  get row
  F77_NAME(dgemm)(chN, chT, &n, &ione, &kmax, &one, rhs.val, &n, lhs.val+r, &m, &zero, b, &n);
}

//  get column for low-rank matrix
template<> 
void acaRk<double>::getcol(size_t c, double *a) const
{
  ptrdiff_t m=nrows(), n=ncols(), kmax=max_rank(), col=c, ione=1;
  const char *chN="N", *chT="T";
  double one=1., zero=0.;
  //  get column
  F77_NAME(dgemm)(chN, chT, &m, &ione, &kmax, &one, lhs.val, &m, rhs.val+c, &n, &zero, a, &m);
}


//  adaptive cross approximation
template<>
void aca(const acafunc<double>& fun, matrix<double>& L, matrix<double>& R, double tol)
{
  ptrdiff_t m=fun.nrows(), n=fun.ncols(), i, k, r=0, c, ione=1;
  ptrdiff_t kmax=std::min<ptrdiff_t>(fun.max_rank(),hopts.kmax);
  const char *chN="N", *chT="T";
  double pone=1., mone=-1., zero=0.;
  
  //  build up low-rank approximation A * B' using ACA
  matrix<double> A(m,kmax,(double)0), B(n,kmax);
  //  summed up norm and new norm
  double Nsum=0, Nk, scale;
  //  vector for pivot elements
  std::vector<ptrdiff_t> row(m);  for (i=0; i<m; i++) row[i]=i;
 
  tic; 
  //  aca loop
  for (k=0; k<kmax; k++)
  {    
    //  fill row  B(:,k)
    fun.getrow((size_t)r,B.val+k*n);
    if (F77_NAME(dnrm2)(&n, B.val+k*n, &ione)<ACATOL) break;
    //  subtract current approximation of A * B'
    if (k) F77_NAME(dgemm)(chN, chT, &n, &ione, &k, &mone, B.val, &n, A.val+r, &m, &pone, B.val+k*n, &n);
    //  pivot column c
    c=F77_NAME(idamax)(&n,B.val+k*n,&ione)-1;
    //  scale B(:,k)
    scale=1./B(c,k);
    F77_NAME(dscal)(&n, &scale, B.val+k*n, &ione);
    
    //  fill column A(:,k)
    fun.getcol((size_t)c,A.val+k*m);
    //  subtract current approximation of A * B'
    if (k) F77_NAME(dgemm)(chN, chT, &m, &ione, &k, &mone, A.val, &m, B.val+c, &n, &pone, A.val+k*m, &m);
    
    //  remove current pivot row find next pivot row
    row.erase(find(row.begin(),row.end(),r));   
    for (r=row.front(), i=0; i<row.size(); i++) if (abs(A(row[i],k))>abs(A(r,k))) r=row[i];
    //  norm of new vector elements
    Nk=F77_NAME(dnrm2)(&m, A.val+k*m, &ione)*F77_NAME(dnrm2)(&n, B.val+k*n, &ione);
    //  check for convergence
    if (Nk<tol*Nsum || row.empty())
      break;
    else
      Nsum=sqrt(pow(Nsum,2)+pow(Nk,2));
  }
  
  //  set output
  L=matrix<double>(m,std::min<ptrdiff_t>(k+1,kmax),A.val);
  R=matrix<double>(n,std::min<ptrdiff_t>(k+1,kmax),B.val);
  //  end timing
  toc("aca");  
}


/*
 * Complex ACA
 */

//  get row for full matrix
template<> 
void acafull<dcmplx>::getrow(size_t r, dcmplx* b) const
{
  ptrdiff_t m=nrows(), n=ncols(), row=r, ione=1;
  //  get row
  F77_NAME(zcopy)(&n, (const double*)(mat.val+row), &m, (double*)b, &ione);
}

//  get column for full matrix
template<> 
void acafull<dcmplx>::getcol(size_t c, dcmplx* a) const
{
  ptrdiff_t m=nrows(), n=ncols(), col=c, ione=1;
  //  get column
  F77_NAME(zcopy)(&m, (const double*)(mat.val+col*m), &ione, (double*)a, &ione);
}

//  get row for low-rank matrix
template<> 
void acaRk<dcmplx>::getrow(size_t r, dcmplx *b) const
{
  ptrdiff_t m=nrows(), n=ncols(), kmax=max_rank(), row=r, ione=1;
  const char *chN="N", *chT="T";
  dcmplx one=1., zero=0.;
  //  get row
  F77_NAME(zgemm)(chN, chT, &n, &ione, &kmax, (const double*)&one, 
          (const double*)rhs.val, &n, (const double*)(lhs.val+r), &m, (const double*)&zero, (double*)b, &n);
}

//  get column for low-rank matrix
template<> 
void acaRk<dcmplx>::getcol(size_t c, dcmplx *a) const
{
  ptrdiff_t m=nrows(), n=ncols(), kmax=max_rank(), col=c, ione=1;
  const char *chN="N", *chT="T";
  dcmplx one=1., zero=0.;
  //  get column
  F77_NAME(zgemm)(chN, chT, &m, &ione, &kmax, (const double*)&one, 
          (const double*)lhs.val, &m, (const double*)(rhs.val+c), &n, (const double*)&zero, (double*)a, &m);
}


//  adaptive cross approximation
template<>
void aca(const acafunc<dcmplx>& fun, matrix<dcmplx>& L, matrix<dcmplx>& R, double tol)
{
  ptrdiff_t m=fun.nrows(), n=fun.ncols(), i, k, r=0, c, ione=1;
  ptrdiff_t kmax=std::min<ptrdiff_t>(fun.max_rank(),hopts.kmax);
  const char *chN="N", *chT="T";
  dcmplx pone=1., mone=-1., zero=0., scale;
  
  //  build up low-rank approximation A * B' using ACA
  matrix<dcmplx> A(m,kmax,(dcmplx)0), B(n,kmax);
  //  summed up norm and new norm
  double Nsum=0, Nk;
  //  vector for pivot elements
  std::vector<ptrdiff_t> row(m);  for (i=0; i<m; i++) row[i]=i;
  std::vector<ptrdiff_t>::iterator it;
  
  tic;
  //  aca loop
  for (k=0; k<kmax; k++)
  {
    //  fill row  B(:,k)
    fun.getrow((size_t)r,B.val+k*n);
    if (F77_NAME(dznrm2)(&n, (const double*)(B.val+k*n), &ione)<ACATOL) break;
    //  subtract current approximation of A * B'
    if (k) F77_NAME(zgemm)(chN, chT, &n, &ione, &k, (const double*)&mone, 
            (const double*)B.val, &n, (const double*)(A.val+r), &m, (const double*)&pone, (double*)(B.val+k*n), &n);
    //  pivot column c
    c=F77_NAME(izamax)(&n,(const double*)(B.val+k*n),&ione)-1;
    //  scale B(:,k)
    scale=1./B(c,k);
    F77_NAME(zscal)(&n, (const double*)&scale, (double*)(B.val+k*n), &ione);
    
    //  fill column A(:,k)
    fun.getcol((size_t)c,A.val+k*m);
    //  subtract current approximation of A * B'
    if (k) F77_NAME(zgemm)(chN, chT, &m, &ione, &k, (const double*)&mone, 
            (const double*)A.val, &m, (const double*)(B.val+c), &n, (const double*)&pone, (double*)(A.val+k*m), &m);

    //  remove current pivot row find next pivot row
    row.erase(find(row.begin(),row.end(),r)); 
    //  compute next pivot
    matrix<dcmplx> work(m,1,(dcmplx)0);
    for (it=row.begin(); it!=row.end(); it++) work[*it]=A(*it,k);
    r=F77_NAME(izamax)(&m,(const double*)work.val,&ione)-1;
    //  norm of new vector elements
    Nk=F77_NAME(dznrm2)(&m, (const double*)(A.val+k*m), &ione)*
       F77_NAME(dznrm2)(&n, (const double*)(B.val+k*n), &ione);
    
    //  check for convergence
    if (Nk<tol*Nsum || row.empty())
      break;
    else
      Nsum=sqrt(pow(Nsum,2)+pow(Nk,2));
  }
  
  //  set output
  L=matrix<dcmplx>(m,std::min<ptrdiff_t>(k+1,kmax),A.val);
  R=matrix<dcmplx>(n,std::min<ptrdiff_t>(k+1,kmax),B.val);
  //  end timing
  toc("aca");
}
