function obj = init( obj, p, impact, width, vel, varargin )
%  INIT - Initialize electron beam excitation.
%  
%  Usage :
%    obj = eelsbase( p, impact, width, vel, op, PropertyPairs )
%  Input
%    p        :  particle object for EELS measurement      
%    impact   :  impact parameter of electron beam
%    width    :  width of electron beam for potential smearing
%    vel      :  electron velocity in units of speed of light  
%    op       :  option structure
%  PropertyName
%    'cutoff'   :  distance for integration refinement  
%    'phiout'   :  half aperture collection angle of spectrometer

%  extract options and property pairs
op = getbemoptions( { 'eels' }, varargin{ : } );
%  cutoff parameter and PHIOUT
if ~isfield( op, 'cutoff' ), op.cutoff = 10 * width;  end
if  isfield( op, 'phiout' ), obj.phiout = op.phiout;  end
%  refine boundary integration
if isfield( op, 'refine' ), p = set( p, 'quad', quadface( op ) );  end

%  save input
[ obj.p, obj.impact, obj.width, obj.vel ] = deal( p, impact, width, vel );

%%  auxiliary quantities
%  maximal enclosure radius for particle
rad = enclosure( p );
%  small quantity
eta = 1e-6;

%  number of impact parameters
n = size( impact, 1 );
%  distance between particle positions and impact parameters
% dist = sqrt(  ...
%   ( repmat( p.pos( :, 1 ), 1, n ) - repmat( impact( :, 1 )', p.n, 1 ) ) .^ 2 +  ...
%   ( repmat( p.pos( :, 2 ), 1, n ) - repmat( impact( :, 2 )', p.n, 1 ) ) .^ 2 );
dist = misc.pdist2( p.pos( :, 1 : 2 ), impact );

%%  crossing points between electron beam and surface elements
%  estimate boundary elements for crossing
[ row, col ] = find( dist <= rad );
%  index which denotes electron beam crossing
cross = false( p.n, n );

for i = unique( row )'
  %  face indices of boundary element
  face = p.faces( i, : );
  face = face( ~isnan( face ) );
  %  coordinates of vertices
  [ xv, yv ] = deal( p.verts( face, 1 ), p.verts( face, 2 ) );
  %  index to impact parameters
  ind = find( row == i );
  %  coordinates of impact parameters
  [ x, y ] = deal( impact( col( ind ), 1 ), impact( col( ind ), 2 ) );
  
  %  crossing points
  [ in, on ] = inpolygon( x, y, xv, yv );
  %  indicate crossing points 
  cross( i, col( ind( in ) ) ) = true;
  
  %  move points on boundary into polygon
  if any( on )
    %  index to impact parameter
    j = col( ind( on ) );
    %  move point
    impact( j, 1 ) = ( 1 - eta ) * impact( j, 1 ) + eta * p.pos( i, 1 );
    impact( j, 2 ) = ( 1 - eta ) * impact( j, 2 ) + eta * p.pos( i, 2 );
  end
end

%%  electron beam trajectories inside particles
%  material in- and outside of faces
inout = zeros( p.n, 2 );
for i = 1 : p.np
  %  index to faces
  ind = p.index( i );
  %  material at in- and outside
  inout( ind, : ) = repmat( p.inout( i, : ), length( ind ), 1 );
end

%  find faces and impact parameters of crossing points
[ i1, j1 ] = find( cross );
%  z-values of crossing points
z = p.pos( i1, 3 ) +  ...
  ( p.nvec( i1, 1 ) .* ( p.pos( i1, 1 ) - impact( j1, 1 ) ) +  ...
    p.nvec( i1, 2 ) .* ( p.pos( i1, 2 ) - impact( j1, 2 ) ) ) ./ p.nvec( i1, 3 );
  
%  allocate output arrays
[ zcut, indimp, indmat ] = deal( [], [], [] );

  
%  loop over all impact parameters
for j2 = 1 : size( impact, 1 )
  %  find crossing points
  i2 = find( j1 == j2 );
  
  %  sort crossing points according to z-value
  [ ~, ind ] = sort( z( i2 ) );
  %  crossing point and index to corresponding face
  zz = z( i2( ind ) );
  i2 = i1( i2( ind ) );
  %  material properties (modify according to surface normal)
  mat = inout( i2, : );
  mat( p.nvec( i2, 3 ) < 0, [ 1, 2 ] ) = mat( p.nvec( i2, 3 ) < 0, [ 2, 1 ] );
    
  %  save z-values of crossing points and indices to impact parameter and
  %  material number
  zcut = [ zcut; zz( 1 : end - 1 ), zz( 2 : end ) ];
  indimp = [ indimp; repmat( j2, length( zz ) - 1, 1 ) ];
  indmat = [ indmat; mat( 2 : end, 1 ) ];
end

%  save output (only trajectories outside of background medium)
obj.z = zcut( indmat ~= 1, : );
[ obj.indimp, obj.indmat ] =  ...
  deal( indimp( indmat ~= 1 ), indmat( indmat ~= 1 ) );
    
%%  face elements with integration over boundary element
%  use minimum distance between electron beams and face elements
obj.indquad = ~isnan( distmin( p, impact, op.cutoff ) ) | cross;
