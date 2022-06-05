//  clustertree.h - Cluster tree.
//
//  For explanation of classes see below.

#include <iostream>
#include <algorithm>
#include <vector>
#include <map>
#include <utility>
#include <fstream>
#include <cstdlib>

#ifndef clustertree_h
#define clustertree_h

#include "hoptions.h"
#include "basemat.h"

//  flag for low-rank and full matrices
#define flagRk   1
#define flagFull 2


/*  The treeiterator class works together with the clustertree class:
 *  
 * //  index of starting cluster
 * size_t ic=1;
 * //  loop over cluster sons
 *  for (tree:iterator it=tree.begin(ic); it!=tree.end(); it++)
 *  {
 *    *it;          //  current cluster
 *    it->num;      //  0 for first son, 1 for second son
 *  }
 */ 
class treeiterator
{
public:
  size_t num, n;
  pair_t ind;
  
  treeiterator() : num(0), n(0) {}
  treeiterator(size_t ic) : num(0), n(1) { ind.first=ic; }
  treeiterator(size_t son1, size_t son2) : num(0), n(2) { ind=pair_t(son1,son2); }
  treeiterator(const treeiterator& it) { *this=it; }
  
  //  assignement operator
  const treeiterator& operator= (const treeiterator& it)
    { num=it.num; n=it.n; ind=it.ind; return *this; }
  //  dummy function for testing of it!=tree.end()
  bool operator!= (const treeiterator& it) const { return num!=n; }
  //  increment operator
  treeiterator& operator++ ()    { num++; return *this; }
  treeiterator& operator++ (int) { num++; return *this; }
  //  reference operator
  size_t  operator* () const { return num==0 ? ind.first : ind.second; }
  //  reverse order
  treeiterator& reverse() 
    { if (n==2) std::swap(ind.first,ind.second); return *this; }
  
  //  number of elements
  size_t size() const { return n; }
  //  dereference operator
  const treeiterator* operator-> () const { return this; }
};

/*  The pairiterator class works together with the clustertree class:
 *  
 * //  loop over cluster sons
 *  for (tree:iterator it=tree.pair_begin(ic0,ic1); it!=tree.pair_end(); it++)
 *  {
 *    it->first;        //  row index
 *    it->second;       //  column index
 *  }
 */ 
class pairiterator
{
public:
  std::vector<pair_t> ind;
  
  pairiterator() {}
  pairiterator(const std::vector<pair_t>& index) : ind(index) {}
  
  bool operator== (const pairiterator& it) const { return ind==it.ind; }
  bool operator!= (const pairiterator& it) const { return ind!=it.ind; }
  //  increment operator
  pairiterator& operator++ ()    { ind.erase(ind.begin()); return *this; }
  pairiterator& operator++ (int) { ind.erase(ind.begin()); return *this; }
  //  reference operator
  pair_t operator* () const { return ind.front(); }
  //  empty iterator
  bool empty() const { return ind.empty(); }
  
  //  number of elements
  size_t size() const { return ind.size(); }
  //  dereference operator
  const pair_t* operator-> () const { return &ind.front(); }
};

/* extern clustertree tree;       //  global tree for acces from H-matrices
 * matrix<size_t> ind1,ind2;      //  index to full and low-rank matrices
 * 
 * tree.getmex(rhs,ind1,ind2);    //  initialize cluster tree from MEX calls
 * tree.fread(fid);               //  read cluster tree from file
 * 
 * tree.sons;                     //  list of cluster sons
 * tree.ind;                      //  row or column indices (ibegin,iend) for clusters
 * tree.ipart;                    //  particle index (only used for Green functions)
 * 
 * tree.size(i);                  //  size of cluster i
 * tree.size(i,j);                //  size of sub-cluster i wrt size of parent cluster j
 * tree.leaf(i);                  //  determine whether cluster i is leaf
 * tree.clear();                  //  clear object
 * tree.name(i,j);                //  "full" for full matrices and "Rk" for low-rank matrices
 * tree.flag(i,j);                //  flagFull or flagRk
 * tree.admiss(i,j);              //  flagFull, flagRk for full and low-rank matrices, 0 else
 */
class clustertree
{    
public:
  typedef treeiterator iterator;
  //  sons and cluster indices, particle indices
  matrix<size_t> sons, ind, ipart; 
  //  admissibility of cluster pairs, to be set in hmatrix
  //  flagRk for cluster pairs admissible to low-rank approximation, flagFull for full matrices, 0 else
  std::map<pair_t,short> ad;  
  
  //  assignement operator
  const clustertree& operator= (const clustertree& tree)
    { sons=tree.sons; ind=tree.ind; ipart=tree.ipart; ad=tree.ad; return *this; }
  //  iterator for loop over sons
  iterator begin(size_t ic=0) const 
    { return leaf(ic) ? iterator(ic) : iterator(sons(ic,0),sons(ic,1)); }
  iterator end() const { return iterator(); }
  //  iterator for loop over clusters
  pairiterator pair_begin(size_t r=0, size_t c=0) const
    { std::vector<pair_t> ind; tree_loop(r,c,ind); return pairiterator(ind); } 
  pairiterator pair_end() const { return pairiterator(); }
  
  //  size of cluster (wrt second cluster)
  pair_t size(size_t i) const { return pair_t(ind(i,0),ind(i,1)); }
  pair_t size(size_t i, size_t j) const { return pair_t(ind(i,0)-ind(j,0),ind(i,1)-ind(j,0)); }
  //  determine whether cluster is leaf
  bool leaf(size_t ic) const { return sons(ic,0)==0 && sons(ic,1)==0; }
  //  clear cluster tree
  clustertree& clear() { sons.clear(); ind.clear(); ad.clear(); return *this; }
  
  //  admissibility of cluster pairs (no further subdivision)
  short admiss(size_t row, size_t col) const
    { 
      std::map<pair_t,short>::const_iterator it=ad.find(pair_t(row,col));
      return it==ad.end() ? 0 : it->second;
    }  
 
  //  name of cluster pair ("Rk" or "full")
  std::string name(size_t row, size_t col)
    { size_t ad=admiss(row,col);  return ad ? (ad==flagRk ? "Rk" : "full") : ""; }
  
  //  read cluster tree from file
  void fread(FILE* fid) 
    {
      sons=matrix<size_t>::fread(fid);
      ind =matrix<size_t>::fread(fid);
      //  second index entry should be post elememt
      for (size_t i=0; i<ind.nrows(); i++) ind(i,1)++;
    }
  
  #ifdef MEX
  //  get cluster tree from MEX function
  void getmex(const mxArray* prhs, matrix<size_t>& ind1, matrix<size_t>& ind2)
    {
      sons =matrix<size_t>::getmex(mxGetField(prhs,0,"sons"  )); 
      ind  =matrix<size_t>::getmex(mxGetField(prhs,0,"ind"   ));
      ipart=matrix<size_t>::getmex(mxGetField(prhs,0,"ipart" ));
      //  second index entry should be post elememt
      for (size_t i=0; i<ind.nrows(); i++) ind(i,1)++; 
      
      //  indices to full and low-rank matrices
      ind1=matrix<size_t>::getmex(mxGetField(prhs,0,"ind1"));
      ind2=matrix<size_t>::getmex(mxGetField(prhs,0,"ind2"));
      //  set admissibility for full and low-rank matrices
      for (size_t i=0; i<ind1.nrows(); i++) ad[pair_t(ind1(i,0),ind1(i,1))]=flagFull;
      for (size_t i=0; i<ind2.nrows(); i++) ad[pair_t(ind2(i,0),ind2(i,1))]=flagRk;      
    }
  #endif //  MEX
  
private:
  void tree_loop(size_t r, size_t c, std::vector<pair_t>& ind) const
  {      
    if (admiss(r,c))
      ind.push_back(pair_t(r,c));
    else
      for (iterator row=begin(r); row!=end(); row++)
      for (iterator col=begin(c); col!=end(); col++)
        tree_loop(*row,*col,ind);
  }
};

//  one tree accessible for everyone
extern clustertree tree;
//  index to full and low-rank matrices
extern matrix<size_t> ind1, ind2;
    
#endif  //  clustertree_h
