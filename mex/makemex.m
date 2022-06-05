function makemex( finp )
%  MAKEMEX - Compile single or multiple MEX files.

if ~exist( 'finp', 'var' )
  finp = { 'hmatfull', 'hmatadd', 'hmatinv', 'hmatmul1', 'hmatmul2',      ...
           'hmatfun', 'hmatlu', 'hmatsolve', 'hmatlsolve', 'hmatrsolve',  ...
           'hmatgreenstat', 'hmatgreenret', 'hmatgreentab1', 'hmatgreentab2' };
elseif ~iscell( finp )
  finp = { finp };
end

switch computer( 'arch' )
  %  Building on Windows Platforms 
  case 'win64'
    %  directory for MEX files
    outdir = 'win64';
    %  BLAS and LAPACK library
    blaslib = fullfile( matlabroot, 'extern', 'lib', computer( 'arch' ), 'microsoft', 'libmwblas.lib' );
    lapacklib = fullfile( matlabroot, 'extern', 'lib', computer( 'arch' ), 'microsoft', 'libmwlapack.lib' );
 
  %  Building on Linux Platforms
  case 'glnxa64'
    %  directory for MEX files
    outdir = 'glnxa64';
    %  BLAS and LAPACK library
    blaslib = '-lmwblas';
    lapacklib = '-lmwlapack';   
    
  %  Building on Apple Mac Platforms
  case 'maci64'
    %  directory for MEX files
    outdir = 'maci64';
    %  BLAS and LAPACK library
    blaslib = '-lmwblas';
    lapacklib = '-lmwlapack';       
end
    
%  directory of header files for hierarchical matrices and ACA
hlibdir = fullfile( pwd, 'hlib' );
acadir = fullfile( pwd, 'acagreen' );
%  HLIB files
basemat = fullfile( 'hlib', 'basemat.cpp' );
aca = fullfile( 'hlib', 'aca.cpp' );
lu = fullfile( 'hlib', 'lu.cpp' );
acagreen = fullfile( 'acagreen', 'acagreen.cpp' );
greentab = fullfile( 'acagreen', 'greentab.cpp' );
interp = fullfile( 'acagreen', 'interp.cpp' );

%  default parameters and libraries
param = { '-v', '-largeArrayDims', '-O',  ...
  ['-I' hlibdir ], [ '-I', acadir ], '-outdir', outdir };
libs = { blaslib, lapacklib };

%  loop over MEX files
for name = finp
  switch name{ : }
    case { 'hmatfull', 'hmatadd', 'hmatinv', 'hmatmul1', 'hmatmul2', 'hmatfun', }
      mex( param{ : }, [ name{ : }, '.cpp' ], basemat, aca, libs{ : } );
    case { 'hmatlu', 'hmatsolve', 'hmatlsolve', 'hmatrsolve' }
      mex( param{ : }, [ name{ : }, '.cpp' ], basemat, aca, lu, libs{ : } );
    case { 'hmatgreenstat', 'hmatgreenret' }
      mex( param{ : }, [ name{ : }, '.cpp' ], basemat, aca, acagreen, libs{ : } );
    case { 'hmatgreentab1', 'hmatgreentab2' }
      mex( param{ : }, [ name{ : }, '.cpp' ], basemat, aca, greentab, interp, libs{ : } );
  end
end
  
