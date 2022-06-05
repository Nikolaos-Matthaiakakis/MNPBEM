function [ sig, obj ] = solve( obj, exc )
%  SOLVE - Solve BEM equations for given excitation.
%
%  Usage for obj = bemstatiter :
%    [ sig, obj ] = solve( obj, exc )
%  Input
%    exc    :  compstruct with fields for external excitation
%  Output
%    sig    :  compstruct with fields for surface charge

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );
%  excitation and size of excitation array
[ b, siz ] = deal( exc.phip( : ), size( exc.phip ) );
 
%  function for matrix multiplication 
fa = @( x ) afun( obj, x );
fm = [];
%  function for preconditioner
if ~isempty( obj.precond ), fm = @( x ) mfun( obj, x ); end

%  iterative solution 
[ x, obj ] = solve@bemiter( obj, [], b, fa, fm );

%  save everything in single structure
sig = compstruct( obj.p, exc.enei, 'sig', reshape( x, siz ) );
