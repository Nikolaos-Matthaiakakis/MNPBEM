function vec = pack( ~, varargin )
%  PACK - Pack scalar and vector potentials into single vector.

if numel( varargin ) == 4
  %  extract input
  [ phi, a, phip, ap ] = deal( varargin{ : } );
else
  %  extract input
  [ phi, apar, aperp, phip, appar, apperp ] = deal( varargin{ : } );
  %  size of vectors
  siz1 = [ size( aperp, 1 ), 2, size( aperp, 2 ) ];
  siz2 = [ size( aperp, 1 ), 1, size( aperp, 2 ) ];
  %  put together vectors
  a  = squeeze( cat( 2, reshape( apar,  siz1 ), reshape( aperp,  siz2 ) ) );
  ap = squeeze( cat( 2, reshape( appar, siz1 ), reshape( apperp, siz2 ) ) );
end
  
%  pack to single vector
vec = [ phi( : ); a( : ); phip( : ); ap( : ) ];

