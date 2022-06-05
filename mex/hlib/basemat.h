//  basemat.h - Simple matrix class with basic functionality.
//
//  The class makes extensive use of BLAS and LAPACK routines for speedup.

/* matrix<double> a(m,n), b(m,n,0.), ... ;  //  initialization
 * 
 * a=matrix<double>::getmex(rhs); //  convert Matlab array to C++ matrix
 * lhs=setmex(a);                 //  copy C++ matrix into Matlab array
 * a=matrix<double>::fread(fid);  //  read matrix from file
 * fid=a.fwrite(fid);             //  write matrix to file
 * 
 * a.nrows();       //  number of rows
 * a.ncols();       //  number of columns
 * a.empty();       //  is matrix empty?
 * 
 * a(i,j);          //  reference
 * a[i]             //  access elements (FORTRAN storage, rows first) 
 * c=a+b;  c=a*b;   //  basic matrix operations
 * 
 * mask_t amask=a.size();         //  get size of matrix (0,mrows,0,ncols)
 * mask_t amask(r0,r1,c0,c1);     //  size of matrix (r0,r1,c0,c1)
 * 
 * at=transp(a);                  //  transpose of matrix
 * b=mask(a,amask)                //  matrix masking
 * copy(a,amask,b,bmask);         //  copy contents from a to b using masking
 * add(a,amask,b,bmask,c,cmask);  //  summation c=a+b using masking
 * c=add(a,amask,b,bmask);        
 *                                //  multiplication c=a*b using masking, type="N", "T"
 * add_mul(a,amask,atype,b,bmask,btype,c,cmask);
 * c=add_mul(a,amask,atype,b,bmask,btype);
 * c=cat(a1,a2);                  //  concatenate matrices horizontally
 * c=cat(nrow,ncol,a1,a2,...);    //  concatenate multiple matrices
 *                                //    works only for specific values of nrow, ncol
 * ai=inv(a);                     //  inverse of matrix (using LAPACK)
 */

#include <iostream>
#include <algorithm>
#include <vector>
#include <string>
#include <fstream>
#include <cstdlib>
#include <cstdarg>

#ifndef basemat_h
#define basemat_h

#include "hoptions.h"

//  class for masking of matrix
class mask_t
{
public:
  //     rows ranging from rbegin to rend (one past last element)
  //  columns ranging from cbegin to cend (one past last element)
  size_t rbegin, rend, cbegin, cend;
  
  //  constructors
  mask_t() {}
  mask_t(size_t ra, size_t rb, size_t ca, size_t cb) : rbegin(ra), rend(rb), cbegin(ca), cend(cb) {}
  mask_t(pair_t r, pair_t c) : rbegin(r.first), rend(r.second), cbegin(c.first), cend(c.second) {}
  
  //  number of rows and columns
  size_t nrows() const { return rend-rbegin; }
  size_t ncols() const { return cend-cbegin; }
};

//  output of vector
std::ostream& operator<< (std::ostream& os, const mask_t& mask);


//  some auxiliary functions for vectors
//  quick initialization of vectors (w/o C++11 standard)
template<class T>
std::vector<T> init_vector(const T& a) 
  { T v[]={a}; return std::vector<T>(v,v+1); }
template<class T>
std::vector<T> init_vector(const T& a, const T& b)
  { T v[]={a,b}; return std::vector<T>(v,v+2); }
template<class T>
std::vector<T> init_vector(const T& a, const T& b, const T& c, const T& d)
  { T v[]={a,b,c,d}; return std::vector<T>(v,v+4); }


template<class T>
class matrix
{
public:
  //  numbers of leading dimensions 
  size_t mld,nld;
  T *val;  

  //  constructors
  matrix<T>() : val(0) {}
  matrix<T>(const matrix<T>& mat) : val(0)  { *this=mat; }
  matrix<T>(size_t m, size_t n, const T* t) : val(0) { allocate(m,n); copy(t); }
  matrix<T>(size_t m, size_t n)             : val(0) { allocate(m,n);          }
  matrix<T>(size_t m, size_t n, const T& t) : val(0) { allocate(m,n); std::fill(val,val+m*n,t); }
  //  destructor
  ~matrix<T>() { if (val) delete[] val; }
  
  //  size of matrix
  size_t nrows() const { return mld; }
  size_t ncols() const { return nld; }
  
  //  assignement operator
  const matrix<T>& operator= (const matrix<T>& mat);
  //  index operator
  T& operator() (size_t i, size_t j) { ASSERT(i<mld && j<nld);  return val[i+j*mld]; }
  const T& operator() (size_t i, size_t j) const { ASSERT(i<mld && j<nld);  return val[i+j*mld]; }
  T& operator[] (size_t i) { ASSERT(i<mld*nld); return val[i]; }
  const T& operator[] (size_t i) const { ASSERT(i<mld*nld); return val[i]; }
  
  //  basic matrix operations
  const matrix<T>& operator+= (const matrix<T>& mat) { return empty() ? *this=mat : add_to(mat,(T)(+1)); }
  const matrix<T>& operator-= (const matrix<T>& mat) { return empty() ? *this=mat : add_to(mat,(T)(-1)); }
  matrix<T> operator+ (const matrix<T>& mat) const   { return matrix<T>(*this).add_to(mat,(T)(+1)); }
  matrix<T> operator- (const matrix<T>& mat) const   { return matrix<T>(*this).add_to(mat,(T)(-1)); }
  matrix<T> operator- () const                       { return matrix<T>(*this).scale((T)(-1)); } 
  matrix<T> operator* (const matrix<T>& mat) const;
  
  //  first and end element
        T* begin()       { return val; }
  const T* begin() const { return val; }
        T* end()         { return val+mld*nld; }
  const T* end()   const { return val+mld*nld; }  
  
  //  empty matrix
  bool empty() const { return val==0; }
  //  matrix size
  mask_t size() const { return mask_t(0,mld,0,nld); }
  //  clear vector
  matrix<T>& clear() { if (val) delete[] val; val=0; return *this; }
  
  //  read matrix from file or write matrix to file
  static matrix<T> fread(FILE* fid);
  FILE* fwrite(FILE* fid) const;
  //  convert Matlab array to C++ matrix
  #ifdef MEX
  static matrix<T> getmex(const mxArray* rhs);
  #endif // MEX
  
private:
  //  allocate memory
  void allocate(size_t m, size_t n);
  //  basic routines for matrix manipulation
  const matrix<T>& copy(const T* t) { std::copy(t,t+mld*nld,val); return *this; }
  const matrix<T>& add_to(const matrix<T>& mat, const T& a=(T)1);
  const matrix<T>& scale(const T& a);
};


//  convert Matlab array to C++ matrix
#ifdef MEX
template<class T>
matrix<T> matrix<T>::getmex(const mxArray* rhs)
{ 
  return matrix<T>(mxGetM(rhs),mxGetN(rhs),(const T*)mxGetPr(rhs)); 
}
template<> matrix<dcmplx> matrix<dcmplx>::getmex(const mxArray* rhs);
#endif

//  specializations for class functions
template<> const matrix<double>& matrix<double>::copy(const double* t);
template<> const matrix<double>& matrix<double>::add_to(const matrix<double>& mat, const double& a);
template<> const matrix<double>& matrix<double>::scale(const double& a);

template<> const matrix<dcmplx>& matrix<dcmplx>::copy(const dcmplx* t);
template<> const matrix<dcmplx>& matrix<dcmplx>::add_to(const matrix<dcmplx>& mat, const dcmplx& a);
template<> const matrix<dcmplx>& matrix<dcmplx>::scale(const dcmplx& a);


//  allocate memory (if needed)
template<class T>
void matrix<T>::allocate(size_t m, size_t n)
{
  //  allocate memory ?
  if (val && (mld!=m || nld!=n))
  {
    delete[] val;
    val=new T[m*n];
  }
  else if (val==NULL)
    val=new T[m*n];
    
  //  save matrix dimensions
  mld=m; nld=n;
}

//  assignement operator
template<class T>
const matrix<T>& matrix<T>::operator= (const matrix<T>& mat) 
{
  //  deal with empty matrices
  if (mat.val==NULL)
  {
    if (val) delete[] val;
    val=NULL;
  }
  else
  {
    allocate(mat.mld,mat.nld);
    copy(mat.val);
  }
  
  return *this;
}

//  transpose matrix
template<class T>
matrix<T> transpose(const matrix<T>& A)
{
  matrix<T> At(A.ncols(),A.nrows());
  
  for (size_t i=0; i<A.nrows(); i++)
  for (size_t j=0; j<A.ncols(); j++)
    At(j,i)=A(i,j);
 
  return At;
}

//  copy contents of matrix B to matrix A using masking
template <class T>
const matrix<T>& copy(const matrix<T>& A, const mask_t& maskA, 
                            matrix<T>& B, const mask_t& maskB)
{
  size_t m=maskA.nrows(), n=maskA.ncols();

  //  copy (InputIterator first, InputIterator last, OutputIterator result) 
  for (size_t j=0; j<n; j++)
    std::copy(&A(maskA.rbegin,maskA.cbegin+j),
              &A(maskA.rbegin,maskA.cbegin+j)+m,&B(maskB.rbegin,maskB.cbegin+j));

  return B;
}

//  mask matrix
template<class T>
matrix<T> mask(const matrix<T>& A, const mask_t& siz)
{
  size_t m=siz.nrows(), n=siz.ncols();
  matrix<T> B(m,n);
  
  return copy(A,siz,B,B.size());
}

//  multiply matrices, C = C + op( A )*op( B ) 
template<class T>
void add_mul(const matrix<T>& A, const mask_t& maskA, char transA,
             const matrix<T>& B, const mask_t& maskB, char transB,
                   matrix<T>& C, const mask_t& maskC)
{  
  //  size of matrices
  size_t mA=maskA.nrows(), nA=maskA.ncols(), mB=maskB.nrows(), nB=maskB.ncols();
  
  if (transA=='N' && transB=='N')
    for (size_t i=0; i<mA; i++)
    for (size_t j=0; j<nB; j++)
    for (size_t k=0; k<mB; k++)
      C(maskC.rbegin+i,maskC.cbegin+j)=
      C(maskC.rbegin+i,maskC.cbegin+j)+A(maskA.rbegin+i,maskA.cbegin+k)*B(maskB.rbegin+k,maskB.cbegin+j);

  else if (transA=='T' && transB=='N')
    for (size_t i=0; i<nA; i++)
    for (size_t j=0; j<nB; j++)
    for (size_t k=0; k<mB; k++)
      C(maskC.rbegin+i,maskC.cbegin+j)=
      C(maskC.rbegin+i,maskC.cbegin+j)+A(maskA.rbegin+k,maskA.cbegin+i)*B(maskB.rbegin+k,maskB.cbegin+j);
      
  else if (transA=='N' && transB=='T')
    for (size_t i=0; i<mA; i++)
    for (size_t j=0; j<mB; j++)
    for (size_t k=0; k<nB; k++)
      C(maskC.rbegin+i,maskC.cbegin+j)=
      C(maskC.rbegin+i,maskC.cbegin+j)+A(maskA.rbegin+i,maskA.cbegin+k)*B(maskB.rbegin+j,maskB.cbegin+k);  
  
  else if (transA=='T' && transB=='T')
    for (size_t i=0; i<nA; i++)
    for (size_t j=0; j<mB; j++)
    for (size_t k=0; k<nB; k++)
      C(maskC.rbegin+i,maskC.cbegin+j)=
      C(maskC.rbegin+i,maskC.cbegin+j)+A(maskA.rbegin+k,maskA.cbegin+i)*B(maskB.rbegin+j,maskB.cbegin+k);
}        

//  specializations using BLAS library
template<>
void add_mul(const matrix<double>& A, const mask_t& maskA, char transA,
             const matrix<double>& B, const mask_t& maskB, char transB,
                   matrix<double>& C, const mask_t& maskC);
template<>
void add_mul(const matrix<dcmplx>& A, const mask_t& maskA, char transA,
             const matrix<dcmplx>& B, const mask_t& maskB, char transB,
                   matrix<dcmplx>& C, const mask_t& maskC);

//  multiply matrices, C = op( A )*op( B ) 
template<class T>
matrix<T> mul(const matrix<T>& A, const mask_t& maskA, char transA,
              const matrix<T>& B, const mask_t& maskB, char transB)
{
  //  size of matrices
  size_t mA=maskA.nrows(), nA=maskA.ncols(), mB=maskB.nrows(), nB=maskB.ncols();
  //  size of return matrix
  size_t m,n;

       if (transA=='N' && transB=='N') m=mA, n=nB; 
  else if (transA=='T' && transB=='N') m=nA, n=nB;
  else if (transA=='N' && transB=='T') m=mA, n=mB;
  else if (transA=='T' && transB=='T') m=nA, n=mB;
  
  //  initialize return array
  matrix<T> C(m,n,(T)0);
  //  add matrix product
  add_mul(A,maskA,transA,B,maskB,transB,C,C.size());
  
  return C;
}

template<class T>
matrix<T> matrix<T>::operator* (const matrix<T>& mat) const
{
  return mul(*this,size(),'N',mat,mat.size(),'N');
}

//  concatenate two matrices horizontally
template<class T>
matrix<T> cat(const matrix<T>& A, const matrix<T>& B)
{
  ASSERT(A.nrows()==B.nrows());
  //  allocate output matrix
  matrix<T> C(A.nrows(),A.ncols()+B.ncols());
  
  copy(A.begin(),A.end(),C.begin());
  copy(B.begin(),B.end(),C.begin()+A.nrows()*A.ncols());
  
  return C;
}

//  specialization using BLAS
template<> matrix<double> cat(const matrix<double>& A, const matrix<double>& B);
template<> matrix<dcmplx> cat(const matrix<dcmplx>& A, const matrix<dcmplx>& B);

//  concatenate matrices
template<class T>
matrix<T> cat(const matrix<const matrix<T>*>& A)
{
  size_t m=A.nrows(), n=A.ncols();    
    
  //  total number of rows and columns
  std::vector<size_t> nr; nr.push_back(0); 
  std::vector<size_t> nc; nc.push_back(0);
  
  for (size_t i=0; i<m; i++) nr.push_back(nr.back()+A(i,0)->nrows()); 
  for (size_t j=0; j<n; j++) nc.push_back(nc.back()+A(0,j)->ncols()); 
  //  return matrix
  matrix<T> a(nr.back(),nc.back());
  
  for (size_t i=0; i<m; i++)
  for (size_t j=0; j<n; j++)
    copy(*A(i,j),A(i,j)->size(),a,mask_t(nr[i],nr[i+1],nc[j],nc[j+1]));
  
  return a; 
}

//  concatenate matrices A(1,2), A(2,1)
template<class T>
matrix<T> cat(size_t m, size_t n, const matrix<T>& a, const matrix<T>& b)
{
  matrix<const matrix<T>*> A(m,n); A[0]=&a; A[1]=&b;
  return cat<T>(A);
}

//  concatenate matrices A(2,2)
template<class T>
matrix<T> cat(size_t m, size_t n, const matrix<T>& a, const matrix<T>& b, 
                                  const matrix<T>& c, const matrix<T>& d)
{
  matrix<const matrix<T>*> A(m,n); A[0]=&a; A[1]=&b; A[2]=&c; A[3]=&d;
  return cat<T>(A);
}

//  concatenate matrices A(2,4)
template<class T>
matrix<T> cat(size_t m, size_t n, const matrix<T>& a, const matrix<T>& b, 
                                  const matrix<T>& c, const matrix<T>& d,
                                  const matrix<T>& e, const matrix<T>& f, 
                                  const matrix<T>& g, const matrix<T>& h)
{
  matrix<const matrix<T>*> A(m,n); A[0]=&a; A[1]=&b; A[2]=&c; A[3]=&d;
                                   A[4]=&e; A[5]=&f; A[6]=&g; A[7]=&h;
  return cat<T>(A);
}

//  matrix inversion (LAPACK)
matrix<double> inv(const matrix<double>&);
matrix<dcmplx> inv(const matrix<dcmplx>&);


#ifdef MEX
//  copy C++ matrix into Matlab array (basemat.cpp)
mxArray* setmex(const matrix<double>& mat);
mxArray* setmex(const matrix<dcmplx>& mat);
#endif

//  read matrix from file
template<class T>
matrix<T> matrix<T>::fread(FILE* fid)
{
  size_t m,n;
  
  std::fread(&m, sizeof(size_t), 1, fid);
  std::fread(&n, sizeof(size_t), 1, fid); 
  
  matrix<T> mat=matrix<T>(m,n);
  std::fread(mat.val, sizeof(T), m*n, fid );
  
  return mat;
}

//  write matrix to file
template<class T>
FILE* matrix<T>::fwrite(FILE* fid) const
{
  std::fwrite(&mld, sizeof(size_t), 1, fid);
  std::fwrite(&nld, sizeof(size_t), 1, fid);
  std::fwrite(val, sizeof(T), mld*nld, fid);
  
  return fid;
}

#endif  //  basemat_h
