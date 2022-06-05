function [ e, h ] = field1( obj, sig, varargin )
%  FIELD - Compute electromagnetic fields with precomputed Green function.
%
%  Usage for obj = meshfield :
%    [ e, h ] = field1( obj, sig, varargin )
%  Input
%    sig        :  surface charges and currents
%                    or COMPSTRUCT object with electromagnetic fields
%    varargin   :  additional parameters to be passed to Green function
%  Output
%    e          :  electric field
%    h          :  magnetic field, [] for quasistatic simulations

if isfield( sig, 'e' )
  %  SIG is treated as field array;
  f = sig;
else
  %  compute electromagnetic fields
  f = field( obj.g, sig, varargin{ : } );
end

%  electric field
e = obj.pt( f.e );
%  size of electric field
siz = size( e );  
if size( obj.x, 2 ) == 1
  siz = [ size( obj.x, 1 ), siz( 2 : end ) ];
else
  siz = [ size( obj.x    ), siz( 2 : end ) ];
end
%  reshape electric field
e = reshape( e, siz );

if ~isfield( f, 'h' )
  h = [];
else
  h = reshape( obj.pt( f.h ), siz );
end
