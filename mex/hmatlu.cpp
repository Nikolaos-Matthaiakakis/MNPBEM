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

//  LU decomposition of H-matrix, deal with calling sequence: tree, A, L, R, [op]
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
    hmatrix<double> A, B;
    B=hmatrix<double>::getmex(&prhs[1]);
  
    timer.clear(); tic;
    //  LU decomposition
    lu(B,A);  
    toc("main");
  
    //  set output
    setmex<double>(A,&plhs[0]);
  }
  else  //  complex input
  {
    hmatrix<dcmplx> A, B;
    B=hmatrix<dcmplx>::getmex(&prhs[1]);
  
    timer.clear(); tic;
    //  LU decomposition
    lu(B,A);  
    toc("main");
  
    //  set output
    setmex<dcmplx>(A,&plhs[0]);
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
