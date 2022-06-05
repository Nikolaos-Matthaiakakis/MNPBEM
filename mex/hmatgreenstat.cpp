#include "mex.h"
#include "matrix.h"

#include "hoptions.h"
#include "clustertree.h"
#include "hmatrix.h"
#include "particle.h"
#include "acagreen.h"

using namespace std;

//  cluster tree
clustertree tree;
//  indices for full and low-rank matrices
matrix<size_t> ind1,ind2;

struct hoptions hopts = { 1e-6, 500 };
map<string,double> timer;

//  fill Green function using aca, deal with calling sequence: p, tree, flag, [op]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  //  particle
  particle p=particle::getmex(prhs[0]);
  //  cluster tree
  tree.getmex(prhs[1],ind1,ind2);
  //  flag
  char str[10];
  mxGetString(prhs[2],str,mxGetM(prhs[2])*mxGetN(prhs[2])+1);
  std::string flag(str);
  //  set tolerance and maximum rank for low-rank matrix
  if (nrhs==4)
  {
    if (mxGetField(prhs[3],0,"htol")) hopts.tol=mxGetScalar(mxGetField(prhs[3],0,"htol"));
    if (mxGetField(prhs[3],0,"kmax")) hopts.kmax=(size_t)mxGetScalar(mxGetField(prhs[3],0,"kmax"));
  }      
  
  //  set up Green function object
  greenstat g(p,flag);
  //  low-rank approximation for Green function
  hmatrix<double> H=g.eval(hopts.tol);
  
  //  create cell arrays for low-rank matrices
  plhs[0]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);
  plhs[1]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);  
  //  loop over low-rank matrices
  for (size_t i=0; i<ind2.nrows(); i++)
  {
    mxSetCell(plhs[0],i,setmex(H.find(ind2(i,0),ind2(i,1))->lhs));
    mxSetCell(plhs[1],i,setmex(H.find(ind2(i,0),ind2(i,1))->rhs));
  }          
    
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();  
}
