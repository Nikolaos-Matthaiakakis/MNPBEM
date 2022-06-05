function exc = field( obj, p, enei )
%  Electric field for dipole excitation.
%
%  Usage for obj = dipolestat :
%    exc = field( obj, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  COMPSTRUCT object which contains the electric field, 
%                  the last two dimensions of exc.e correspond to the 
%                  positions and dipole moments

%  dipole positions
pt = obj.pt;
%  compute electric field for unit dipole
e = efield( p.pos, pt.pos, obj.dip, pt.eps1( enei ) );

% %  refine electric fields in boundary elements for particles
% try
%   %  test for particle
%   p.area;
% 
%   %  default options
%   if isempty( obj.varargin ),  obj.varargin = { bemoptions };  end
%   %  refinement matrix
%   ir = green.refinematrix( pt, p, obj.varargin{ : } );
%   %  faces to be refined
%   reface = find( any( ir ~= 0, 1 ) );
%   %  positions and weights for boundary element integration
%   [ pos, w ] = quad( p, reface );
% 
%   %  loop over faces to be refined
%   for face = reshape( reface, 1, [] )
%     %  index to dipole positions 
%     ind = find( ir( :, face ) ~= 0 );
%     %  integration points with refinement
%     [ ~, col, w2 ] = find( w( reface == face, : ) );  
%     %  electric field at integration positions
%     ee = efield( pos( col, : ), pt.pos( ind, : ), obj.dip( ind, :, : ) );
%     %  refine electric field in boundary element FACE
%     e( face, :, ind, : ) = matmul( w2, ee ) / sum( w2 );
%   end
% end

% save in compstruct
exc = compstruct( p, enei, 'e', e );


function e = efield( pos1, pos2, dip, eps )
%  EFIELD - Electric field at POS1 for dipole positions POS2 and 
%           dipole moments DIP.

%  allocate output array
e = zeros( size( pos1, 1 ), 3, size( pos2, 1 ), size( dip, 3 ) );

%  distance vector 
x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
z = bsxfun( @minus, pos1( :, 3 ), pos2( :, 3 ) .' );
%  distance
r = sqrt( x .^ 2 + y .^ 2 + z .^ 2 );
%  normalize distance vector
[ x, y, z ] = deal( x ./ r, y ./ r, z ./ r );

for i = 1 : size( dip, 3 )
  %  dipole moment
  dx = repmat( dip( :, 1, i ) .', size( pos1, 1 ), 1 );
  dy = repmat( dip( :, 2, i ) .', size( pos1, 1 ), 1 );
  dz = repmat( dip( :, 3, i ) .', size( pos1, 1 ), 1 );
  %  inner product [ x, y, z ] with dip
  in = x .* dx + y .* dy + z .* dz;
  %  electric field [Jackson Eq. (4.13)]
  %    screen electric field of unit dipole by dielectric function of
  %    embedding medium
  e( :, 1, :, i ) = ( 3 * x .* in - dx ) ./ bsxfun( @times, r .^ 3, eps .' );
  e( :, 2, :, i ) = ( 3 * y .* in - dy ) ./ bsxfun( @times, r .^ 3, eps .' );
  e( :, 3, :, i ) = ( 3 * z .* in - dz ) ./ bsxfun( @times, r .^ 3, eps .' );
end
