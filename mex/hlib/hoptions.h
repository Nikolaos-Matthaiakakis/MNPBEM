//  hoptions.h - Options for hierarchical matrices.

/* ERROR(txt);      //  write error message to stdout or MEX-output
 * ASSERT(txt);     //  standard assert or message to "assert.txt" (MEX)
 * 
 * hoptions hopts = { htol, kmax };     //  options array for H-matrices
 * std::map<std::string,double> timer;  //  timer 
 * 
 * tic;             //  start timer
 * ...
 * toc(txt);        //  add txt entry to timer 
 */

#ifndef hoptions_h
#define hoptions_h

// #define NDEBUG  // turn off assert

#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <cassert>
#include <ctime>
#include <complex>
#include <cstddef>

#include "blas.h"

#define MEX
#define TIMER

#ifdef MEX
  #include "mex.h"
  #define ERROR(err) { mexPrintf("%s\n",err); exit(1); }
  #define ASSERT(x) {                                                                                     \
    if (!(x)) {                                                                                           \
      std::ofstream fid("assert.txt", std::ofstream::out | std::ofstream::app);                           \
      fid << "assertion in line " << __LINE__ << " of file " << __FILE__ << " failed."  << std::endl;     \
      fid.close();                                                                                        \
    }                                                                                                     \
  }
#else
  #define ERROR(err) { std:cout << err << std::endl;  exit(1); }
  #define ASSERT(x) assert(x)
#endif

#if !defined(_WIN32)
  #define F77_NAME(x) x ## _
#else
  #define F77_NAME(x) x
#endif

typedef std::complex<double> dcmplx;
typedef std::pair<size_t,size_t> pair_t;

//  option array for H-matrices
struct hoptions
{
  double tol;       //  tolerance for truncation of Rk matrices 
  size_t kmax;      //  maximum rank for low-rank matrices
};
extern struct hoptions hopts;

#ifdef TIMER
  extern std::map<std::string,double> timer;
  #define tic std::clock_t start=std::clock()
  #define toc(id) timer[id]+=(std::clock()-start)/(double)CLOCKS_PER_SEC
#else
  #define tic
  #define toc(id)
#endif

#endif // hoptions_h
