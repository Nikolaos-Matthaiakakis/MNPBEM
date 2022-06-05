//  greentab.h - Interpolation of tabulated Green function values.

#include <string>

#include "hoptions.h"
#include "basemat.h"
#include "clustertree.h"
#include "hmatrix.h"
#include "aca.h"
#include "particle.h"
#include "interp.h"

#ifndef greentab_h
#define greentab_h


//  base class
class greentab : public acafunc<dcmplx>
{
public:
  //  particle
  particle p;
  //  row and columnn of cluster and cluster size
  size_t row, col;
  mask_t siz;
  
  //  constructors
  greentab() {}
  greentab(const particle& part) : p(part) {}
  
  //  number of rows and columns
  size_t nrows() const { return siz.nrows(); }
  size_t ncols() const { return siz.ncols(); }
  //  maximum rank of low-rank matrices
  size_t max_rank() const { return std::min<size_t>(nrows(),ncols()); }
  //  get rows and columns of matrix
  virtual void getrow(size_t r, dcmplx* b) const = 0;
  virtual void getcol(size_t c, dcmplx* a) const = 0;
  //  initialize cluster
  void init(size_t r, size_t c) 
    { siz=mask_t(tree.size(row=r),tree.size(col=c)); }
      
  //  evaluate Green function matrices
  hmatrix<dcmplx> eval(size_t i, size_t j, double tol);
};


/*
 * Interpolation of Green function
 */

class greentabG2 : public greentab
{
public:
  //  upper or lower medium of layer structure
  char uplo;
  //  interpolator for Green function
  interp2<dcmplx> gtab;
  double rmin;
  
  //  constructor
  greentabG2(const particle& p, const mxArray* prhs[]);
  //  get rows and columns of matrix
  void getrow(size_t r, dcmplx* b) const;
  void getcol(size_t c, dcmplx* a) const;
};

class greentabG3 : public greentab
{
public:
  //  upper or lower medium of layer structure
  char uplo;
  //  interpolator for Green function
  interp3<dcmplx> gtab;
  double rmin;
  
  //  constructor
  greentabG3(const particle& p, const mxArray* prhs[]);
  //  get rows and columns of matrix
  void getrow(size_t r, dcmplx* b) const;
  void getcol(size_t c, dcmplx* a) const;
};


/*
 * Interpolation of surface derivative of Green function.
 */

class greentabF2 : public greentab
{
public:
  //  upper or lower medium of layer structure
  char uplo;
  //  interpolator for surface derivatives of Green functions
  interp2<dcmplx> frtab, fztab;
  double rmin;
  
  //  constructor
  greentabF2(const particle& p, const mxArray* prhs[]);  
  //  get rows and columns of matrix
  void getrow(size_t r, dcmplx* b) const;
  void getcol(size_t c, dcmplx* a) const;
};

class greentabF3 : public greentab
{
public:
  //  upper or lower medium of layer structure
  char uplo;
  //  interpolator for surface derivatives of Green functions
  interp3<dcmplx> frtab, fztab;
  double rmin;
  
  //  constructor
  greentabF3(const particle& p, const mxArray* prhs[]);  
  //  get rows and columns of matrix
  void getrow(size_t r, dcmplx* b) const;
  void getcol(size_t c, dcmplx* a) const;
};


#endif  //  greentab_h
