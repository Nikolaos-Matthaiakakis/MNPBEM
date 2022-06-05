#include <string>
#include <cmath>

#include "greentab.h"
#include "mex.h"

std::string getstring(const mxArray* rhs)
{
  char str[10];
  mxGetString(rhs,str,mxGetM(rhs)*mxGetN(rhs)+1);
  
  return std::string(str);
}

//  evaluate Green function matrix 
hmatrix<dcmplx> greentab::eval(size_t i, size_t j, double tol)
{
  //  low-rank matrices and H-matrix
  matrix<dcmplx> L,R;
  hmatrix<dcmplx> H;
  
  //  loop over clusters
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++)
    if (tree.admiss(it->first,it->second)==flagRk)
    {
      //  set cluster
      init(it->first,it->second);
      //  fill Green function matrix using ACA
      aca<dcmplx>(*this,L,R,tol);
      //  set submatrix
      H[*it]=submatrix<dcmplx>(row,col,L,R);
    }
  
  return H;
} 

/*
 * 2D interpolation of Green function
 */

//  constructor
greentabG2::greentabG2(const particle& part, const mxArray* prhs[]) : greentab(part)
{
  matrix<double>  r=matrix<double>::getmex(mxGetField(prhs[0],0,"r"));
  matrix<double> z1=matrix<double>::getmex(mxGetField(prhs[0],0,"z1"));
  matrix<dcmplx>  g=matrix<dcmplx>::getmex(mxGetField(prhs[0],0,"G"));
  //  storage type "lin" or "log"
  std::string rmod=getstring(mxGetField(prhs[0],0,"rmod"));
  std::string zmod=getstring(mxGetField(prhs[0],0,"zmod"));

  //  initialize interpolator
  gtab=interp2<dcmplx>(r,rmod,z1,zmod,g);
  //  layer index
  size_t ind=(size_t)mxGetScalar(prhs[1]);
  //  uppermost layer
  uplo=(ind==1) ? 'U' : 'L';
  //  minimum radial distance
  rmin=r[0];
}

//  get row for 2D Green function
void greentabG2::getrow(size_t r, dcmplx* b) const
{
  ptrdiff_t n=ncols(), np=p.n, rr=siz.rbegin+r, cc=siz.cbegin;
  matrix<double> rho(n,1), z(n,1);
  
  //  distances
  for (ptrdiff_t c=0; c<n; c++) 
  {
    //  polar distance
    rho[c]=sqrt(pow(p.pos[rr]-p.pos[cc+c],2)+pow(p.pos[rr+np]-p.pos[cc+c+np],2));
    rho[c]=std::max<double>(rmin,rho[c]);
    //  z-distance
    z[c]=p.z[rr]+(uplo=='U' ? 1 : -1)*p.z[cc+c];
  }
  
  //  perform interpolation
  matrix<dcmplx> g=gtab(rho,z);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t c=0; c<n; c++) 
    b[c]=g[c]/sqrt(pow(rho[c],2)+pow(z[c],2))*p.area[cc+c];
}

//  get column for 2D Green function
void greentabG2::getcol(size_t c, dcmplx* a) const
{
  ptrdiff_t m=nrows(), np=p.n, rr=siz.rbegin, cc=siz.cbegin+c;
  matrix<double> rho(m,1), z(m,1);
  
  //  distances
  for (ptrdiff_t r=0; r<m; r++) 
  {
    //  polar distance
    rho[r]=sqrt(pow(p.pos[rr+r]-p.pos[cc],2)+pow(p.pos[rr+r+np]-p.pos[cc+np],2));
    rho[r]=std::max<double>(rmin,rho[r]);
    //  z-distance
    z[r]=p.z[rr+r]+(uplo=='U' ? 1 : -1)*p.z[cc];
  }
  
  //  perform interpolation
  matrix<dcmplx> g=gtab(rho,z);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t r=0; r<m; r++) 
    a[r]=g[r]/sqrt(pow(rho[r],2)+pow(z[r],2))*p.area[cc];
}

/*
 * 3D interpolation of Green function
 */

//  constructor
greentabG3::greentabG3(const particle& part, const mxArray* prhs[]) : greentab(part)
{
  matrix<double>  r=matrix<double>::getmex(mxGetField(prhs[0],0,"r"));
  matrix<double> z1=matrix<double>::getmex(mxGetField(prhs[0],0,"z1"));
  matrix<double> z2=matrix<double>::getmex(mxGetField(prhs[0],0,"z2"));
  matrix<dcmplx>  g=matrix<dcmplx>::getmex(mxGetField(prhs[0],0,"G"));
  //  storage type "lin" or "log"
  std::string rmod=getstring(mxGetField(prhs[0],0,"rmod"));
  std::string zmod=getstring(mxGetField(prhs[0],0,"zmod"));
  //  initialize interpolator
  gtab=interp3<dcmplx>(r,rmod,z1,zmod,z2,zmod,g);
  //  minimum radial distance
  rmin=r[0];  
}

//  get row for 3D Green function
void greentabG3::getrow(size_t r, dcmplx* b) const
{
  ptrdiff_t n=ncols(), np=p.n, rr=siz.rbegin+r, cc=siz.cbegin;
  matrix<double> rho(n,1), z1(n,1), z2(n,1);
  
  //  distances
  for (ptrdiff_t c=0; c<n; c++) 
  {
    //  polar distance
    rho[c]=sqrt(pow(p.pos[rr]-p.pos[cc+c],2)+pow(p.pos[rr+np]-p.pos[cc+c+np],2));
    rho[c]=std::max<double>(rmin,rho[c]);
    //  z-distances
    z1[c]=p.z[rr];
    z2[c]=p.z[cc+c];
  }
  
  //  perform interpolation
  matrix<dcmplx> g=gtab(rho,z1,z2);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t c=0; c<n; c++) 
    b[c]=g[c]/sqrt(pow(rho[c],2)+pow(z1[c]+z2[c],2))*p.area[cc+c];
}

//  get column for 3D Green function
void greentabG3::getcol(size_t c, dcmplx* a) const
{
  ptrdiff_t m=nrows(), np=p.n, rr=siz.rbegin, cc=siz.cbegin+c;
  matrix<double> rho(m,1), z1(m,1), z2(m,1);
  
  //  distances
  for (ptrdiff_t r=0; r<m; r++) 
  {
    //  polar distance
    rho[r]=sqrt(pow(p.pos[rr+r]-p.pos[cc],2)+pow(p.pos[rr+r+np]-p.pos[cc+np],2));
    rho[c]=std::max<double>(rmin,rho[c]);
    //  z-distances
    z1[r]=p.z[rr+r];
    z2[r]=p.z[cc];
  }
  
  //  perform interpolation
  matrix<dcmplx> g=gtab(rho,z1,z2);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t r=0; r<m; r++) 
    a[r]=g[r]/sqrt(pow(rho[r],2)+pow(z1[r]+z2[r],2))*p.area[cc];
}

/*
 * 2D interpolation of surface derivative of Green function
 */

//  constructor
greentabF2::greentabF2(const particle& part, const mxArray* prhs[]) : greentab(part)
{
  matrix<double>  r=matrix<double>::getmex(mxGetField(prhs[0],0,"r"));
  matrix<double> z1=matrix<double>::getmex(mxGetField(prhs[0],0,"z1"));
  matrix<dcmplx> fr=matrix<dcmplx>::getmex(mxGetField(prhs[0],0,"Fr"));
  matrix<dcmplx> fz=matrix<dcmplx>::getmex(mxGetField(prhs[0],0,"Fz"));
  //  storage type "lin" or "log"
  std::string rmod=getstring(mxGetField(prhs[0],0,"rmod"));
  std::string zmod=getstring(mxGetField(prhs[0],0,"zmod"));

  //  initialize interpolators
  frtab=interp2<dcmplx>(r,rmod,z1,zmod,fr);
  fztab=interp2<dcmplx>(r,rmod,z1,zmod,fz);
  //  layer index
  size_t ind=(size_t)mxGetScalar(prhs[1]);
  //  uppermost layer
  uplo=(ind==1) ? 'U' : 'L';
  //  minimum radial distance
  rmin=r[0];  
}

//  get row for 2D surface derivative of Green function
void greentabF2::getrow(size_t r, dcmplx* b) const
{
  ptrdiff_t n=ncols(), np=p.n, rr=siz.rbegin+r, cc=siz.cbegin;
  matrix<double> rho(n,1), z(n,1), in(n,1);
  double x, y;
  
  //  distances
  for (ptrdiff_t c=0; c<n; c++) 
  {
    //  relative distance
    x=p.pos[rr   ]-p.pos[cc+c   ];
    y=p.pos[rr+np]-p.pos[cc+c+np];
    //  polar distance and inner product
    rho[c]=std::max<double>(rmin,sqrt(pow(x,2)+pow(y,2)));
    in[c]=(p.nvec[rr]*x+p.nvec[rr+np]*y)/rho[c];
    //  z-distance
    z[c]=p.z[rr]+(uplo=='U' ? 1 : -1)*p.z[cc+c];
  }
  
  //  perform interpolation
  matrix<dcmplx> fr=frtab(rho,z), fz=fztab(rho,z);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t c=0; c<n; c++) 
  {
    double d=sqrt(pow(rho[c],2)+pow(z[c],2));
    b[c]=(in[c]*rho[c]*fr[c]+p.nvec[rr+2*np]*z[c]*fz[c])/pow(d,3)*p.area[cc+c];
  }
}

//  get column for 2D surface derivative of Green function
void greentabF2::getcol(size_t c, dcmplx* a) const
{
  ptrdiff_t m=nrows(), np=p.n, rr=siz.rbegin, cc=siz.cbegin+c;
  matrix<double> rho(m,1), z(m,1), in(m,1);
  double x, y;
  
  //  distances
  for (ptrdiff_t r=0; r<m; r++) 
  {
    //  relative distance
    x=p.pos[rr+r   ]-p.pos[cc   ];
    y=p.pos[rr+r+np]-p.pos[cc+np];
    //  polar distance and inner product
    rho[r]=std::max<double>(rmin,sqrt(pow(x,2)+pow(y,2)));
    in[r]=(p.nvec[rr+r]*x+p.nvec[rr+r+np]*y)/rho[r];
    //  z-distance
    z[r]=p.z[rr+r]+(uplo=='U' ? 1 : -1)*p.z[cc];
  }
  
  //  perform interpolation
  matrix<dcmplx> fr=frtab(rho,z), fz=fztab(rho,z);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t r=0; r<m; r++) 
  {
    double d=sqrt(pow(rho[r],2)+pow(z[r],2));
    a[r]=(in[r]*rho[r]*fr[r]+p.nvec[rr+r+2*np]*z[r]*fz[r])/pow(d,3)*p.area[cc];
  }
}

/*
 * 3D interpolation of surface derivative of Green function
 */

//  constructor
greentabF3::greentabF3(const particle& part, const mxArray* prhs[]) : greentab(part)
{
  matrix<double>  r=matrix<double>::getmex(mxGetField(prhs[0],0,"r"));
  matrix<double> z1=matrix<double>::getmex(mxGetField(prhs[0],0,"z1"));
  matrix<double> z2=matrix<double>::getmex(mxGetField(prhs[0],0,"z2"));
  matrix<dcmplx> fr=matrix<dcmplx>::getmex(mxGetField(prhs[0],0,"Fr"));
  matrix<dcmplx> fz=matrix<dcmplx>::getmex(mxGetField(prhs[0],0,"Fz"));
  //  storage type "lin" or "log"
  std::string rmod=getstring(mxGetField(prhs[0],0,"rmod"));
  std::string zmod=getstring(mxGetField(prhs[0],0,"zmod"));
  //  initialize interpolators
  frtab=interp3<dcmplx>(r,rmod,z1,zmod,z2,zmod,fr);
  fztab=interp3<dcmplx>(r,rmod,z1,zmod,z2,zmod,fz);
  //  minimum radial distance
  rmin=r[0];  
}

//  get row for 3D surface derivative of Green function
void greentabF3::getrow(size_t r, dcmplx* b) const
{
  ptrdiff_t n=ncols(), np=p.n, rr=siz.rbegin+r, cc=siz.cbegin;
  matrix<double> rho(n,1), z1(n,1), z2(n,1), in(n,1);
  double x, y;
  
  //  distances
  for (ptrdiff_t c=0; c<n; c++) 
  {
    //  relative distance
    x=p.pos[rr   ]-p.pos[cc+c   ];
    y=p.pos[rr+np]-p.pos[cc+c+np];
    //  polar distance and inner product
    rho[c]=std::max<double>(rmin,sqrt(pow(x,2)+pow(y,2)));
    in[c]=(p.nvec[rr]*x+p.nvec[rr+np]*y)/rho[c];
    //  z-distances
    z1[c]=p.z[rr];
    z2[c]=p.z[cc+c];
  }
  
  //  perform interpolation
  matrix<dcmplx> fr=frtab(rho,z1,z2), fz=fztab(rho,z1,z2);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t c=0; c<n; c++) 
  {
    double z=z1[c]+z2[c], d=sqrt(pow(rho[c],2)+pow(z,2));
    b[c]=(in[c]*rho[c]*fr[c]+p.nvec[rr+2*np]*z*fz[c])/pow(d,3)*p.area[cc+c];
  }
}

//  get column for 3D surface derivative of Green function
void greentabF3::getcol(size_t c, dcmplx* a) const
{
  ptrdiff_t m=nrows(), np=p.n, rr=siz.rbegin, cc=siz.cbegin+c;
  matrix<double> rho(m,1), z1(m,1), z2(m,1), in(m,1);
  double x, y;
  
  //  distances
  for (ptrdiff_t r=0; r<m; r++) 
  {
    //  relative distance
    x=p.pos[rr+r   ]-p.pos[cc   ];
    y=p.pos[rr+r+np]-p.pos[cc+np];
    //  polar distance and inner product
    rho[r]=std::max<double>(rmin,sqrt(pow(x,2)+pow(y,2)));
    in[r]=(p.nvec[rr+r]*x+p.nvec[rr+r+np]*y)/rho[r];
    //  z-distances
    z1[r]=p.z[rr+r];
    z2[r]=p.z[cc];
  }
  
  //  perform interpolation
  matrix<dcmplx> fr=frtab(rho,z1,z2), fz=fztab(rho,z1,z2);
  //  Green function, for interpolation see 
  //    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  for (ptrdiff_t r=0; r<m; r++) 
  {
    double z=z1[r]+z2[r], d=sqrt(pow(rho[r],2)+pow(z,2));
    a[r]=(in[r]*rho[r]*fr[r]+p.nvec[rr+r+2*np]*z*fz[r])/pow(d,3)*p.area[cc];
  }
}
