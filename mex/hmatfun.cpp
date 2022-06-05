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


//  ACA functor for MEX function matrix
template<class T>
class acamex : public acafunc<T>
{
public:
  //  MEX pointers for function handle
  mxArray *fun;
  //  row and columnn of cluster and cluster size
  size_t row, col;
  mask_t siz;  
  
  //  constructors
  acamex<T>() {}
  acamex<T>(const mxArray *rhs) { fun=const_cast<mxArray *>(rhs); }
  
  //  number of rows and columns
  size_t nrows() const { return siz.nrows(); }
  size_t ncols() const { return siz.ncols(); }
  //  maximum rank of low-rank matrices
  size_t max_rank() const { return std::min(nrows(),ncols()); }
  //  get rows and columns of matrix
  void getrow(size_t r, T* b) const
    { getmex(repmat(siz.rbegin+r,ncols()),index(siz.cbegin,ncols()),b); }
  void getcol(size_t c, T* a) const 
    { getmex(index(siz.rbegin,nrows()),repmat(siz.cbegin+c,nrows()),a); }
  
  //  evaluate low-rank matrices
  hmatrix<T> eval(size_t i, size_t j, double tol);
  //  initialize cluster
  void init(size_t r, size_t c) 
    { siz=mask_t(tree.size(row=r),tree.size(col=c)); }
  
private:
  //  get values from Matlab function
  void getmex(const matrix<size_t>& r, const matrix<size_t>& c, T* val) const;
  //  index in interval [ start, start + n ] (add one because of different Matlab indexing)
  static matrix<size_t> index(size_t start, size_t n)
    { matrix<size_t> ind(n,1);  for (size_t i=0; i<n; i++) ind[i]=start+i+1; return ind; }
  //  copy val to matrix of size n (add one because of different Matlab indexing)
  static matrix<size_t> repmat(size_t val, size_t n) 
    { return matrix<size_t>(n,1,(size_t)(val+1)); }
};

//  specializations
template<> void acamex<double>::getmex(const matrix<size_t>& r, const matrix<size_t>& c, double *val) const;
template<> void acamex<dcmplx>::getmex(const matrix<size_t>& r, const matrix<size_t>& c, dcmplx *val) const;

template<class T>
hmatrix<T> acamex<T>::eval(size_t i, size_t j, double tol)
{
  //  low-rank matrices and H-matrix
  matrix<T> L,R;
  hmatrix<T> H;
  
  //  loop over clusters
  for (pairiterator it=tree.pair_begin(i,j); it!=tree.pair_end(); it++)
    if (tree.admiss(it->first,it->second)==flagRk)
    {
      //  set cluster
      init(it->first,it->second);
      //  fill matrix using ACA
      aca<T>(*this,L,R,tol);
      //  set submatrix
      H[*it]=submatrix<T>(row,col,L,R);
    }
  
  return H;
}

//  fill Green function using aca, deal with calling sequence: tree, fun, zflag, i, j, [op]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  //  cluster tree
  tree.getmex(prhs[0],ind1,ind2);
  //  complex flag
  bool zflag=*(const bool*)mxGetPr(prhs[2]);
  //  starting clusters
  size_t i=*(const size_t*)mxGetPr(prhs[3]);
  size_t j=*(const size_t*)mxGetPr(prhs[4]);
  //  set tolerance and maximum rank for low-rank matrix
  if (nrhs==6)
  {
    if (mxGetField(prhs[5],0,"htol")) hopts.tol=mxGetScalar(mxGetField(prhs[5],0,"htol"));
    if (mxGetField(prhs[5],0,"kmax")) hopts.kmax=(size_t)mxGetScalar(mxGetField(prhs[5],0,"kmax"));
  }  
  
  //  create cell arrays for low-rank matrices
  plhs[0]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);
  plhs[1]=mxCreateCellMatrix((mwSize)ind2.nrows(),1);  
  
  
  if (!zflag)  //  real matrix
  {
    //  set up ACA object
    acamex<double> fun(prhs[1]);
    //  compute low-rank approximation using aca
    hmatrix<double> H=fun.eval(i,j,hopts.tol);
  
    //  loop over low-rank matrices
    for (size_t i=0; i<ind2.nrows(); i++)
    {
      mxSetCell(plhs[0],i,setmex(H.find(ind2(i,0),ind2(i,1))->lhs));
      mxSetCell(plhs[1],i,setmex(H.find(ind2(i,0),ind2(i,1))->rhs));
    }          
  }
  else  //  complex matrix
  {
    //  set up ACA object
    acamex<dcmplx> fun(prhs[1]);
    //  compute low-rank approximation using aca
    hmatrix<dcmplx> H=fun.eval(i,j,hopts.tol);
  
    //  loop over low-rank matrices
    for (size_t i=0; i<ind2.nrows(); i++)
    {
      mxSetCell(plhs[0],i,setmex(H.find(ind2(i,0),ind2(i,1))->lhs));
      mxSetCell(plhs[1],i,setmex(H.find(ind2(i,0),ind2(i,1))->rhs));
    }              
  }
  
  //  clear globals
  tree.clear(); ind1.clear(); ind2.clear(); timer.clear();  
}


/*
 * Specializations for acamex
 */

//  get data from external Matlab function (double precision)
template<> 
void acamex<double>::getmex(const matrix<size_t>& r, const matrix<size_t>& c, double *val) const
{
  mxArray *rhs[3], *lhs;
  const double *p;
  //  allocate arrays for Matlab call
  rhs[0]=fun;
  rhs[1]=mxCreateNumericMatrix(r.nrows(),1,mxUINT64_CLASS,mxREAL);
  rhs[2]=mxCreateNumericMatrix(c.nrows(),1,mxUINT64_CLASS,mxREAL);
  //  copy requested rows and columns to Matlab arrays
  std::copy(r.begin(),r.end(),(size_t*)mxGetPr(rhs[1]));
  std::copy(c.begin(),c.end(),(size_t*)mxGetPr(rhs[2]));
  
  //  call Matlab function
  mexCallMATLAB(1,&lhs,3,rhs,"feval");
  //  copy return values
  p=(const double*)mxGetPr(lhs);
  std::copy(p,p+r.nrows(),val);
  
  //  clean up
  mxDestroyArray(lhs);
  mxDestroyArray(rhs[1]);
  mxDestroyArray(rhs[2]);
}

//  get data from external Matlab function (complex)
template<> 
void acamex<dcmplx>::getmex(const matrix<size_t>& r, const matrix<size_t>& c, dcmplx *val) const
{
  mxArray *rhs[3], *lhs;
  //  allocate arrays for Matlab call
  rhs[0]=fun;
  rhs[1]=mxCreateNumericMatrix(r.nrows(),1,mxUINT64_CLASS,mxREAL);
  rhs[2]=mxCreateNumericMatrix(c.nrows(),1,mxUINT64_CLASS,mxREAL);
  //  copy requested rows and columns to Matlab arrays
  std::copy(r.begin(),r.end(),(size_t*)mxGetPr(rhs[1]));
  std::copy(c.begin(),c.end(),(size_t*)mxGetPr(rhs[2]));
  
  //  call Matlab function
  mexCallMATLAB(1,&lhs,3,rhs,"feval");
  //  copy return values
  ptrdiff_t n=r.nrows(), ione=1, itwo=2;
  //  copy real and imaginary parts
  F77_NAME(dcopy)(&n, mxGetPr(lhs), &ione, (double*)val,   &itwo);
  F77_NAME(dcopy)(&n, mxGetPi(lhs), &ione, (double*)val+1, &itwo);
  
  //  clean up
  mxDestroyArray(lhs);
  mxDestroyArray(rhs[1]);
  mxDestroyArray(rhs[2]);
}
