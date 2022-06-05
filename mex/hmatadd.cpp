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


//  add two H-matrices, deal with calling sequence: tree, A1, L1, R1, A1, L1, R1, [op]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  //  cluster tree
  tree.getmex(prhs[0],ind1,ind2);
  //  options
  if (nrhs==8)
  {
    if (mxGetField(prhs[7],0,"htol")) hopts.tol=mxGetScalar(mxGetField(prhs[7],0,"htol"));
    if (mxGetField(prhs[7],0,"kmax")) hopts.kmax=(size_t)mxGetScalar(mxGetField(prhs[7],0,"kmax"));
  }
  
  //  real input ?
  if (!mxIsComplex(mxGetCell(prhs[1],0)))
  {  
    hmatrix<double> A,B;
    //  get input
    A=hmatrix<double>::getmex(&prhs[1]);
    B=hmatrix<double>::getmex(&prhs[4]);  
    //  set output
    setmex<double>(A+B,plhs);
  }
  else  //  complex input
  {
    hmatrix<dcmplx> A,B;
    //  get input
    A=hmatrix<dcmplx>::getmex(&prhs[1]);
    B=hmatrix<dcmplx>::getmex(&prhs[4]);  
    //  set output
    setmex<dcmplx>(A+B,plhs);    
  }
  
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();  
}
