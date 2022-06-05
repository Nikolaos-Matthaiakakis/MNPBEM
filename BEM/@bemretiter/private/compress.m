function hmat = compress( obj, hmat )
%  COMPRESS - Compress H-matrices for preconditioner.
%
%  Usage for obj = bemretiter :
%    hmat = compress( obj, hmat )
%  Input
%    hmat     :  hierarchical matrix

%  change tolerance and maximal rank for low-rank matrices
hmat.htol = max( obj.op.htol );
hmat.kmax = min( obj.op.kmax );
