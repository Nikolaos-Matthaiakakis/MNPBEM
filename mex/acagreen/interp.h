//  interp.h - 2D and 3D interpolation.

#include <string>

#include "hoptions.h"
#include "basemat.h"

#ifndef interp_h
#define interp_h

//  linear and logarithmic interpolation
matrix<size_t> linind(const matrix<double>&, const matrix<double>&);
matrix<size_t> logind(const matrix<double>&, const matrix<double>&);

/*
 * 2D interpolation
 */

template<class T>
class interp2 
{
public:
  matrix<double> xtab, ytab;
  matrix<T> vtab;
  //  index functions
  matrix<size_t> (*funx)(const matrix<double>&, const matrix<double>&);
  matrix<size_t> (*funy)(const matrix<double>&, const matrix<double>&);
  
  //  constructors
  interp2() {}
  interp2(
    const matrix<double>& x, const std::string& xflag,
    const matrix<double>& y, const std::string& yflag, const matrix<T>& v) : xtab(x), ytab(y), vtab(v)
    {
      funx=(xflag=="lin") ? linind : logind;
      funy=(yflag=="lin") ? linind : logind;
    }
  
  //  perform 2D interpolation
  matrix<T> operator() (const matrix<double>& x, const matrix<double>& y) const;
};

//  perform 2D interpolation
template<class T>
matrix<T> interp2<T>::operator() (const matrix<double>& x, const matrix<double>& y) const
{
  size_t mtab=xtab.nrows()*xtab.ncols(), m=x.nrows(), n=x.ncols();
  matrix<size_t> ix=(*funx)(xtab,x), iy=(*funy)(ytab,y);
  //  bin coordinates
  matrix<double> xbin(m,n);  for (size_t i=0,ii; i<m*n; i++) ii=ix[i], xbin[i]=(x[i]-xtab[ii])/(xtab[ii+1]-xtab[ii]);
  matrix<double> ybin(m,n);  for (size_t i=0,ii; i<m*n; i++) ii=iy[i], ybin[i]=(y[i]-ytab[ii])/(ytab[ii+1]-ytab[ii]);
  //  interpolated values
  matrix<T> v(x.nrows(),x.ncols());
  
  for (size_t i=0; i<m*n; i++)
  {
    //  convert subscripts to linear indices
    size_t ind=ix[i]+iy[i]*mtab;
    double xb=xbin[i], xa=1-xb, yb=ybin[i], ya=1-yb;
    
    #define vv(i,j) vtab[ind+i+j*mtab]
    
    //  linear interpolation
    v[i]=xa*ya*vv(0,0)+xb*ya*vv(1,0)+xa*yb*vv(0,1)+xb*yb*vv(1,1);
    
    #undef vv
  }
  
  return v;
}

/*
 * 3D interpolation
 */

template<class T>
class interp3 
{
public:
  matrix<double> xtab, ytab, ztab;
  matrix<T> vtab;
  //  index functions
  matrix<size_t> (*funx)(const matrix<double>&, const matrix<double>&);
  matrix<size_t> (*funy)(const matrix<double>&, const matrix<double>&);
  matrix<size_t> (*funz)(const matrix<double>&, const matrix<double>&);
  
  //  constructors
  interp3() {}
  interp3(
    const matrix<double>& x, const std::string& xflag,
    const matrix<double>& y, const std::string& yflag, 
    const matrix<double>& z, const std::string& zflag, const matrix<T>& v) : xtab(x), ytab(y), ztab(z), vtab(v)
    {
      funx=(xflag=="lin") ? linind : logind;
      funy=(yflag=="lin") ? linind : logind;
      funz=(yflag=="lin") ? linind : logind;
    }
  
  //  perform 3D interpolation
  matrix<T> operator() (const matrix<double>& x, const matrix<double>& y, const matrix<double>& z) const;
};

//  perform 3D interpolation
template<class T>
matrix<T> interp3<T>::operator() (const matrix<double>& x, const matrix<double>& y, const matrix<double>& z) const
{
  //  number of x and y values
  size_t numx=xtab.nrows()*xtab.ncols(), numy=xtab.nrows()*ytab.ncols();
  //  interpolation indices
  size_t m=x.nrows(), n=x.ncols();
  matrix<size_t> ix=(*funx)(xtab,x), iy=(*funy)(ytab,y), iz=(*funz)(ztab,z);
  //  bin coordinates
  matrix<double> xbin(m,n);  for (size_t i=0,ii; i<m*n; i++) ii=ix[i], xbin[i]=(x[i]-xtab[ii])/(xtab[ii+1]-xtab[ii]);
  matrix<double> ybin(m,n);  for (size_t i=0,ii; i<m*n; i++) ii=iy[i], ybin[i]=(y[i]-ytab[ii])/(ytab[ii+1]-ytab[ii]);
  matrix<double> zbin(m,n);  for (size_t i=0,ii; i<m*n; i++) ii=iz[i], zbin[i]=(z[i]-ztab[ii])/(ztab[ii+1]-ztab[ii]);
  //  interpolated values
  matrix<T> v(x.nrows(),x.ncols());
  
  for (size_t i=0; i<m*n; i++)
  {
    //  convert subscripts to linear indices
    size_t ind=ix[i]+iy[i]*numx+iz[i]*numy;
    double xb=xbin[i], xa=1-xb, yb=ybin[i], ya=1-yb, zb=zbin[i], za=1-zb;
    
    #define vv(i,j,k) vtab[ind+i+j*numx+k*numx*numy]
    
    //  linear interpolation
    v[i]=xa*ya*za*vv(0,0,0)+xb*ya*za*vv(1,0,0)+xa*yb*za*vv(0,1,0)+xb*yb*za*vv(1,1,0)+
         xa*ya*zb*vv(0,0,1)+xb*ya*zb*vv(1,0,1)+xa*yb*zb*vv(0,1,1)+xb*yb*zb*vv(1,1,1);
    
    #undef vv
  }
  
  return v;
}

#endif  //  interp_h
