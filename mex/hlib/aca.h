//  aca.h - Adaptive cross approximation.

#include <iostream>
#include <algorithm>
#include <vector>

#ifndef aca_h
#define aca_h

#include "hoptions.h"
#include "basemat.h"
#include "hmatrix.h"

//  tolerance for termination of ACA loop
#define ACATOL 1e-10    

/*
 * Base class and function for ACA
 */

//  virtual ACA functor
template<class T>
class acafunc 
{
public:
  //  number of rows and columns
  virtual size_t nrows() const = 0;
  virtual size_t ncols() const = 0;
  //  maximum rank of low-rank matrices
  virtual size_t max_rank() const = 0;
  //  get rows and columns of matrix
  virtual void getrow(size_t r, T* b) const = 0;
  virtual void getcol(size_t c, T* a) const = 0;  
};

//  low-rank approximation of matrix using ACA
template<class T>
void aca(const acafunc<T>& fun, matrix<T>& L, matrix<T>& R, double tol);

/*
 * ACA for full matrix
 */

//  ACA functor for full matrix
template<class T>
class acafull : public acafunc<T>
{
public:
  const matrix<T>& mat;
  
  //  constructor
  acafull<T>(const matrix<T>& src) : mat(src) {}
  
  // number of rows and columns
  size_t nrows() const { return mat.nrows(); }
  size_t ncols() const { return mat.ncols(); }
  //  maximum rank of low-rank matrices 
  size_t max_rank() const { return std::min<ptrdiff_t>(nrows(),ncols()); }
  //  get rows and columns of matrix
  void getrow(size_t r, T* b) const;
  void getcol(size_t c, T* a) const;
};

//  specializations
template<> void acafull<double>::getrow(size_t r, double* b) const;
template<> void acafull<double>::getcol(size_t c, double* a) const;

template<> void acafull<dcmplx>::getrow(size_t r, dcmplx* b) const;
template<> void acafull<dcmplx>::getcol(size_t c, dcmplx* a) const;

//  low-rank approximation of full matrix using ACA
template<class T>
void aca(const matrix<T>& mat, matrix<T>& L, matrix<T>& R, double tol)
{
  aca(acafull<T>(mat),L,R,tol);
}

/*
 * ACA for low-rank matrix
 */

//  ACA functor for low-rank matrix
template<class T>
class acaRk : public acafunc<T>
{
public:
  const matrix<T> &lhs, &rhs;
  
  //  constructor
  acaRk<T>(const matrix<T>& L, const matrix<T>& R) : lhs(L), rhs(R) {}
  
  // number of rows and columns
  size_t nrows() const { return lhs.nrows(); }
  size_t ncols() const { return rhs.nrows(); }
  //  maximum rank of low-rank matrices 
  size_t max_rank() const { return lhs.ncols(); }
  //  get rows and columns of matrix
  void getrow(size_t r, T* b) const;
  void getcol(size_t c, T* a) const;
};

//  specializations
template<> void acaRk<double>::getrow(size_t r, double* b) const;
template<> void acaRk<double>::getcol(size_t c, double* a) const;

template<> void acaRk<dcmplx>::getrow(size_t r, dcmplx* b) const;
template<> void acaRk<dcmplx>::getcol(size_t c, dcmplx* a) const;

//  low-rank approximation of low-rank matrix using ACA
template<class T>
void aca(matrix<T>& L, matrix<T>& R, double tol)
{
  aca(acaRk<T>(L,R),L,R,tol);
}

#endif  //  aca_h
