function [ sig, obj ] = solve( obj, exc )
%  SOLVE - Solve BEM equations for given excitation.
%
%  Usage for obj = bemretiter :
%    [ sig, obj ] = solve( obj, exc )
%  Input
%    exc    :  compstruct with fields for external excitation
%  Output
%    sig    :  compstruct with fields for surface charges and currents

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );

%  external excitation
[ phi, a, De, alpha ] = excitation( obj, exc );
%  size of excitation arrays
[ siz1, siz2 ] = deal( size( phi ), size( a ) );
%  pack everything to single vector
b = pack( obj, phi, a, De, alpha );

%  function for matrix multiplication 
fa = @( x ) afun( obj, x );
fm = [];
%  function for preconditioner
if ~isempty( obj.precond ),  fm = @( x ) mfun( obj, x );  end
%  iterative solution 
[ x, obj ] = solve@bemiter( obj, [], b, fa, fm );

%  unpack and save solution vector
[ sig1, h1, sig2, h2 ] = unpack( obj, x );
%  reshape surface charges and currents
sig1 = reshape( sig1, siz1 );  h1 = reshape( h1, siz2 );
sig2 = reshape( sig2, siz1 );  h2 = reshape( h2, siz2 );
%  save everything in single structure
sig = compstruct( obj.p, exc.enei,  ...
                    'sig1', sig1, 'sig2', sig2, 'h1', h1, 'h2', h2 );
