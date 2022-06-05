#include <iostream>
#include <vector>
#include <algorithm>
#include <cmath>

#include "hoptions.h"
#include "aca.h"
#include "acagreen.h"

/*
 * Static Green function
 */

void greenstat::getrow(size_t r, double* b) const
{
  ptrdiff_t n=ncols(), np=p.n, rr=siz.rbegin+r, cc=siz.cbegin, ione=1, ithree=3;
  double d, pos[3];

  for (ptrdiff_t c=0; c<n; c++)
  {
    //  relative position
    for (ptrdiff_t k=0; k<3; k++) pos[k]=p.pos[rr+np*k]-p.pos[cc+c+np*k];
    //  distance
    d=F77_NAME(dnrm2)(&ithree, pos, &ione);
    
    //  Green function or surface derivative
    if (flag=="G")
      b[c]=1./d*p.area[cc+c];
    else
      b[c]=-F77_NAME(ddot)(&ithree, pos, &ione, p.nvec+rr, &np)/pow(d,3)*p.area[cc+c];
  }
}

void greenstat::getcol(size_t c, double* a) const
{
  ptrdiff_t m=nrows(), np=p.n, rr=siz.rbegin, cc=siz.cbegin+c, ione=1, ithree=3;
  double d, pos[3];

  for (ptrdiff_t r=0; r<m; r++)
  {
    //  relative position
    for (ptrdiff_t k=0; k<3; k++) pos[k]=p.pos[rr+r+np*k]-p.pos[cc+np*k];
    //  distance
    d=F77_NAME(dnrm2)(&ithree, pos, &ione);
    
    //  Green function or surface derivative
    if (flag=="G")
      a[r]=1./d*p.area[cc];
    else
      a[r]=-F77_NAME(ddot)(&ithree, pos, &ione, p.nvec+rr+r, &np)/pow(d,3)*p.area[cc];
  }
}

hmatrix<double> greenstat::eval(double tol)
{
  //  low-rank matrices and H-matrix
  matrix<double> L,R;
  hmatrix<double> H;
  
  //  loop over clusters
  for (pairiterator it=tree.pair_begin(); it!=tree.pair_end(); it++)
    if (tree.admiss(it->first,it->second)==flagRk)
    {
      //  set cluster
      init(it->first,it->second);
      //  fill Green function matrix using ACA
      aca<double>(*this,L,R,tol);
      //  set submatrix
      H[*it]=submatrix<double>(row,col,L,R);
    }
  
  return H;
}

/*
 * Retarded Green function
 */

void greenret::getrow(size_t r, dcmplx* b) const
{
  ptrdiff_t n=ncols(), np=p.n, rr=siz.rbegin+r, cc=siz.cbegin, ione=1, ithree=3;
  double d, pos[3], in;
  dcmplx fac, iunit(0,1);

  for (ptrdiff_t c=0; c<n; c++)
  {
    //  relative position
    for (ptrdiff_t k=0; k<3; k++) pos[k]=p.pos[rr+np*k]-p.pos[cc+c+np*k];
    //  distance and phase factor
    d=F77_NAME(dnrm2)(&ithree, pos, &ione);
    fac=exp(iunit*wav*d);
    
    //  Green function or surface derivative
    if (flag=="G")
      b[c]=fac/d*p.area[cc+c];
    else
    {
      in=F77_NAME(ddot)(&ithree, pos, &ione, p.nvec+rr, &np);
      b[c]=in*(iunit*wav-1./d)*fac/pow(d,2)*p.area[cc+c];
    }
  }
}

void greenret::getcol(size_t c, dcmplx* a) const
{
  ptrdiff_t m=nrows(), np=p.n, rr=siz.rbegin, cc=siz.cbegin+c, ione=1, ithree=3;
  double d, pos[3], in;
  dcmplx fac, iunit(0,1);

  for (ptrdiff_t r=0; r<m; r++)
  {
    //  relative position
    for (ptrdiff_t k=0; k<3; k++) pos[k]=p.pos[rr+r+np*k]-p.pos[cc+np*k];
    //  distance
    d=F77_NAME(dnrm2)(&ithree, pos, &ione);
    fac=exp(iunit*wav*d);
    
    //  Green function or surface derivative
    if (flag=="G")
      a[r]=fac/d*p.area[cc];
    else
    {
      in=F77_NAME(ddot)(&ithree, pos, &ione, p.nvec+rr+r, &np);
      a[r]=in*(iunit*wav-1./d)*fac/pow(d,2)*p.area[cc];
    }
  }
}

hmatrix<dcmplx> greenret::eval(size_t i, size_t j, double tol)
{
  //  low-rank matrices and H-matrix
  matrix<dcmplx> L,R;
  hmatrix<dcmplx> H;
   
  //  loop over clusters
  for (pairiterator it=tree.pair_begin(); it!=tree.pair_end(); it++)
    if (tree.admiss(it->first,it->second)==flagRk && 
        tree.ipart[it->first]==i && tree.ipart[it->second]==j)
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
