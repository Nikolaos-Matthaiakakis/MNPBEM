//  particle.h - Discretized particle boundary.

#include <iostream>
#include <algorithm>
#include <vector>

#include "hoptions.h"
#include "basemat.h"

#ifndef particle_h
#define particle_h

//  discretized particle boundary
class particle 
{
public:
  //  number of boundary elements
  size_t n;
  //  arrays for centroids, normal vectors and areas of boundary elements
  const double *pos, *nvec, *area;
  //  distance to closest layer (for layer structure)
  const double *z;
  
  particle() {}
  particle(const particle& p) { *this=p; }
  
  const particle& operator= (const particle& p)
    { n=p.n; pos=p.pos; nvec=p.nvec; area=p.area; z=p.z; return *this; }
  
  //  convert Matlab structure to particle
  #ifdef MEX
  static particle getmex(const mxArray* rhs)
    {
      particle p;
      
      //  number of boundary elements
      p.n=mxGetM(mxGetField(rhs,0,"pos"));
      //  centroids, normal vectors and areas of boundary elements
      p.pos =mxGetPr(mxGetField(rhs,0,"pos" ));
      p.nvec=mxGetPr(mxGetField(rhs,0,"nvec"));
      p.area=mxGetPr(mxGetField(rhs,0,"area"));
      //  distance to closest layer (for layerstructure)
      if (mxGetField(rhs,0,"z" )) p.z=mxGetPr(mxGetField(rhs,0,"z" ));
      
      return p;
    }
  #endif
};

#endif  //  particle_h
