#include "mex.h"
#include "matrix.h"

#include "hoptions.h"
#include "clustertree.h"
#include "hmatrix.h"

using namespace std;

//  cluster tree
clustertree tree;
//  indices for full and low-rank matrices
matrix<size_t> ind1,ind2;

struct hoptions hopts = { 1e-6, 500 };
map<string,double> timer;

//  invert H-matrix, deal with calling sequence: tree, A, L, R, [op]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  tree.getmex(prhs[0],ind1,ind2);
  //  set tolerance and maximum rank for low-rank matrix
  if (nrhs==5)
  {
    if (mxGetField(prhs[4],0,"htol")) hopts.tol=mxGetScalar(mxGetField(prhs[4],0,"htol"));
    if (mxGetField(prhs[4],0,"kmax")) hopts.kmax=(size_t)mxGetScalar(mxGetField(prhs[4],0,"kmax"));
  }    
  
  //  real input ?
  if (!mxIsComplex(mxGetCell(prhs[1],0)))
  {
    hmatrix<double> A,Ai;
    A=hmatrix<double>::getmex(&prhs[1]);
  
    timer.clear(); tic;
    //  inversion of H-matrix
    Ai=inv(A);
    toc("main");
    
    //  set output
    setmex<double>(Ai,plhs);
  }
  else  //  complex input
  {
    hmatrix<dcmplx> A,Ai;
    A=hmatrix<dcmplx>::getmex(&prhs[1]);
  
    timer.clear(); tic;
    //  inversion of H-matrix
    Ai=inv(A);
    toc("main");    
    
    //  set output
    setmex<dcmplx>(Ai,plhs);
  }


  //  timer statistics
  if (nlhs==4)
  {
    plhs[3]=mxCreateStructMatrix(1,1,0,NULL);
    //  loop over timer fields
    for (map<string,double>::iterator it=timer.begin(); it!=timer.end(); it++)
    {
      mxAddField(plhs[3],&it->first[0]);
      mxSetField(plhs[3],0,&it->first[0],mxCreateDoubleScalar(it->second));
    }
  } 
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();  
}
