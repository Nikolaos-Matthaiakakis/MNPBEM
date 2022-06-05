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

//  compute X*(L*U) = B, deal with calling sequence: tree, A1, L1, R1, A2, L2, R2, key, [op]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  tree.getmex(prhs[0],ind1,ind2);  
  char key=*mxGetChars(prhs[7]);
  //  set tolerance and maximum rank for low-rank matrix
  if (nrhs==9)
  {
    if (mxGetField(prhs[8],0,"htol")) hopts.tol=mxGetScalar(mxGetField(prhs[8],0,"htol"));
    if (mxGetField(prhs[8],0,"kmax")) hopts.kmax=(size_t)mxGetScalar(mxGetField(prhs[8],0,"kmax"));
  }      

  //  real input ?
  if (!mxIsComplex(mxGetCell(prhs[1],0)))
  {  
    hmatrix<double> B=hmatrix<double>::getmex(&prhs[1]), A=hmatrix<double>::getmex(&prhs[4]), X;
  
    timer.clear(); tic;
    //  solve matrix equation using LU decomposition
    if (key=='U' || key=='N') rsolve(B,A,X,0,0,'U');
    if (key=='L' || key=='N') rsolve(X,A,X,0,0,'L');
    toc("main");
    
    //  set output
    setmex<double>(X,&plhs[0]);
  }
  else  //  complex input
  {  
    hmatrix<dcmplx> B=hmatrix<dcmplx>::getmex(&prhs[1]), A=hmatrix<dcmplx>::getmex(&prhs[4]), X;
  
    timer.clear(); tic;
    //  solve matrix equation using LU decomposition
    if (key=='U' || key=='N') rsolve(B,A,X,0,0,'U');
    if (key=='L' || key=='N') rsolve(X,A,X,0,0,'L');
    toc("main");

    //  set output
    setmex<dcmplx>(X,&plhs[0]);
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
