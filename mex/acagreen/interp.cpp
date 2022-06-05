#include <cmath>
#include <algorithm>

#include "hoptions.h"
#include "interp.h"

//  interpolation for linear equidistant mesh
matrix<size_t> linind(const matrix<double>& xtab, const matrix<double>& x)
{
  //  number of tabulated and interpolation values
  size_t ntab=xtab.nrows()*xtab.ncols(), n=x.nrows()*x.ncols();
  //  stepsize 
  double h=(xtab[ntab-1]-xtab[0])/(double)(ntab-1);
  //  index array
  matrix<size_t> ind(x.nrows(),x.ncols());
  
  for (size_t i=0; i<n; i++) ind[i]=std::min<size_t>((size_t)((x[i]-xtab[0])/h),ntab-2);
  
  return ind;
}

//   interpolation for logarithmic equidistant mesh
matrix<size_t> logind(const matrix<double>& xtab, const matrix<double>& x)
{
  //  number of tabulated and interpolation values
  size_t ntab=xtab.nrows()*xtab.ncols(), n=x.nrows()*x.ncols();
  //  limits and stepsize 
  double a=log10(xtab[0]), b=log10(xtab[ntab-1]), h=(b-a)/(double)(ntab-1);
  //  index array
  matrix<size_t> ind(x.nrows(),x.ncols());
  
  for (size_t i=0; i<n; i++) ind[i]=std::min<size_t>((size_t)((log10(x[i])-a)/h),ntab-2);
  
  return ind;
}