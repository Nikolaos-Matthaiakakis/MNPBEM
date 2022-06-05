//  acagreen.h - Fill Green function matrix using adaptive cross approximation.

#include <iostream>
#include <algorithm>
#include <vector>
#include <cmath>

#include "hoptions.h"
#include "basemat.h"
#include "clustertree.h"
#include "hmatrix.h"
#include "aca.h"
#include "particle.h"

#ifndef acagreen_h
#define acagreen_h

/*
 * ACA function functor for static Green function
 */

class greenstat : public acafunc<double>
{
public:
  //  particle and flag ('G' or 'F')
  particle p;
  std::string flag;
  //  row and columnn of cluster and cluster size
  size_t row, col;
  mask_t siz;
  
  greenstat() {};
  greenstat(const particle& pin, const std::string& flagin) : p(pin), flag(flagin) {}
  greenstat(const greenstat& g) { *this=g; }
  
  const greenstat& operator= (const greenstat& g) { p=g.p; flag=g.flag; return *this; }
  
  //  number of rows and columns
  size_t nrows() const { return siz.nrows(); }
  size_t ncols() const { return siz.ncols(); }
  //  maximum rank of low-rank matrices
  size_t max_rank() const { return std::min<size_t>(nrows(),ncols()); }
  //  get rows and columns of matrix
  void getrow(size_t r, double* b) const;
  void getcol(size_t c, double* a) const;
  
  //  initialize cluster
  void init(size_t r, size_t c) 
    { siz=mask_t(tree.size(row=r),tree.size(col=c)); }
      
  //  evaluate Green function matrices
  hmatrix<double> eval(double tol);
};  
  
/*
 * ACA function functor for retarded Green function
 */

class greenret : public acafunc<dcmplx>
{
public:
  //  particle and flag ('G' or 'F')
  particle p;
  std::string flag;
  //  wavenumber
  dcmplx wav;
  //  row and columnn of cluster and cluster size
  size_t row, col;
  mask_t siz;
  
  greenret() {};
  greenret(const particle& pin, const std::string& flagin, const dcmplx& wavin) 
                                              : p(pin), flag(flagin), wav(wavin) {}
  greenret(const greenret& g) { *this=g; }
  
  const greenret& operator= (const greenret& g) 
    { p=g.p; flag=g.flag; wav=g.wav; return *this; }
  
  //  number of rows and columns
  size_t nrows() const { return siz.nrows(); }
  size_t ncols() const { return siz.ncols(); }
  //  maximum rank of low-rank matrices
  size_t max_rank() const { return std::min<size_t>(nrows(),ncols()); }
  //  get rows and columns of matrix
  void getrow(size_t r, dcmplx* b) const;
  void getcol(size_t c, dcmplx* a) const;
  
  //  initialize cluster
  void init(size_t r, size_t c) 
    { siz=mask_t(tree.size(row=r),tree.size(col=c)); }
      
  //  evaluate Green function matrices
  hmatrix<dcmplx> eval(size_t i, size_t j, double tol);
};  
  
#endif  //  acagreen_h
