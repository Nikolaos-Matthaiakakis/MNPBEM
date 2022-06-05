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


//  convert H-matrix to full matrix, deal with calling sequence: tree, A, L, R
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  tree.getmex(prhs[0],ind1,ind2);
  
  //  real input ?
  if (!mxIsComplex(mxGetCell(prhs[1],0)))
  {
    hmatrix<double> A=hmatrix<double>::getmex(&prhs[1]);
    //  expand matrix to full size
    plhs[0]=setmex(full(A));
  }
  else  //  complex input
  {
    hmatrix<dcmplx> A=hmatrix<dcmplx>::getmex(&prhs[1]);
    //  expand matrix to full size
    plhs[0]=setmex(full(A));    
  }
  
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();
}
