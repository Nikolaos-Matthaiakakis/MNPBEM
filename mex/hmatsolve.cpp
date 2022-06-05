#include "mex.h"
#include "matrix.h"

#include "hoptions.h"
#include "clustertree.h"
#include "hmatrix.h"
#include "lu.h"

using namespace std;

//  cluster tree
clustertree tree;
//  indices for full and low-rank matrices
matrix<size_t> ind1,ind2;

struct hoptions hopts = { 1e-6, 100 };
map<string,double> timer;

//  matrix inversion using LU decomposition, deal with calling sequence: tree, A, L, R, b, key
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  tree.getmex(prhs[0],ind1,ind2); 
  char key=*mxGetChars(prhs[5]);
  
  //  real input ?
  if (!mxIsComplex(mxGetCell(prhs[1],0)))
  {
    hmatrix<double> A=hmatrix<double>::getmex(&prhs[1]);
    matrix<double> b=matrix<double>::getmex(prhs[4]);
  
    //  solve matrix equation using LU decomposition
    if (key=='L' || key=='N') solve(A,b,0,'L');
    if (key=='U' || key=='N') solve(A,b,0,'U');
  
    //  set output
    plhs[0]=setmex(b);   
  }
  else  //  complex input
  {
    hmatrix<dcmplx> A=hmatrix<dcmplx>::getmex(&prhs[1]);
    matrix<dcmplx> b=matrix<dcmplx>::getmex(prhs[4]);
  
    //  solve matrix equation using LU decomposition
    if (key=='L' || key=='N') solve(A,b,0,'L');
    if (key=='U' || key=='N') solve(A,b,0,'U');
    
    //  set output
    plhs[0]=setmex(b);       
  }
  
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();  
}
