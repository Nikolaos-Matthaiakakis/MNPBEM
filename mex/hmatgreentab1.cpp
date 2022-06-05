#include "mex.h"
#include "matrix.h"

#include "hoptions.h"
#include "basemat.h"
#include "clustertree.h"
#include "particle.h"
#include "interp.h"
#include "greentab.h"

using namespace std;

//  cluster tree
clustertree tree;
//  indices for full and low-rank matrices
matrix<size_t> ind1,ind2;

struct hoptions hopts = { 1e-6, 100 };
map<string,double> timer;


//  interpolation, deal with calling sequence: particle, tree, row, col, tab, ind1, ind2, op );  
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 
  //  particle
  particle p=particle::getmex(prhs[0]);
  //  cluster tree
  tree.getmex(prhs[1],ind1,ind2);
 //  starting clusters
  size_t i=*(const size_t*)mxGetPr(prhs[2]);
  size_t j=*(const size_t*)mxGetPr(prhs[3]);  

  //  options
  if (nrhs==8)
  {
    if (mxGetField(prhs[7],0,"htol")) hopts.tol=mxGetScalar(mxGetField(prhs[7],0,"htol"));
    if (mxGetField(prhs[7],0,"kmax")) hopts.kmax=(size_t)mxGetScalar(mxGetField(prhs[7],0,"kmax"));
  }    
  
  //  Green function matrix
  hmatrix<dcmplx> G;
  
  //  2D interpolation table
  if (mxIsScalar(mxGetField(prhs[4],0,"z2"))) 
  {
    greentabG2 gtab(p,&prhs[4]);
    G=gtab.eval(i,j,hopts.tol);
  }
  else  //  3D interpolation table
  {
    greentabG3 gtab(p,&prhs[4]);
    G=gtab.eval(i,j,hopts.tol);    
  }
  
  //  create cell arrays for low-rank matrices
  plhs[0]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);
  plhs[1]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);  
  //  loop over low-rank matrices
  for (size_t i=0; i<ind2.nrows(); i++)
  {
    mxSetCell(plhs[0],i,setmex(G.find(ind2(i,0),ind2(i,1))->lhs));
    mxSetCell(plhs[1],i,setmex(G.find(ind2(i,0),ind2(i,1))->rhs));
  }          
 
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();  
}
