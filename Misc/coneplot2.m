function varargout = coneplot2( pos, vec, varargin )
%  CONEPLOT2 - Plot vectors at given positions using cones.
%
%  Usage :
%    coneplot2( pos, vec, 'PropertyName', PropertyValue, ... )
%  Input
%    pos        :  positions where cones are plotted
%    vec        :  vectors to be plotted
%  PropertyName
%    scale      :  scaling factor for vectors
%    sfun       :  scaling function for vectors
%                    ( e.g. fun = @( x ) ( sqrt( x ) ) )

if isempty( get( 0, 'CurrentFigure' ) )
  new = true; 
else
  new = isempty( get( gcf, 'CurrentAxes' ) );
end

%  extract input
op = getbemoptions( varargin{ : } );
%  set default values
if ~isfield( op, 'scale' );  op.scale = 1;            end
if ~isfield( op, 'fun'   );  op.sfun = @( x ) ( x );  end

%  vector length
len = vecnorm( vec );
%  scaling function
scale =   op.scale * op.sfun( len / max( len ) );
%  cone plot
h = coneplot( pos, vec, len, scale );
%  set output
[ varargout{ 1 : nargout } ] = deal( h );

%  plot options
lighting phong;  
shading interp;

if new
  axis off;  axis equal;  axis fill;
  camlight headlight;    
  view( 1, 40 );
end


function h = coneplot( pos, vec, len, scale )
%  CONEPLOT - Cone plot for vectors at positions.

%  cone patch
[ u, v, w ] = cylinder( 0.6 * [ 0, 1, 0.5, 0.5, 0 ], 20 );
%  set z-values for arrow
w = repmat( [ 2, 0, 0, - 1, - 1 ]', 1, size( w, 2 ) );
%  face-vertex structure
fv = surf2patch( u, v, w );
[ verts, faces ] = deal( fv.vertices, fliplr( fv.faces ) );
%  number of vertices
nverts = size( verts, 1 );

%  transform vectors to spherical coordinates
[ phi, theta ] = cart2sph( vec( :, 1 ), vec( :, 2 ), vec( :, 3 ) );
theta = pi / 2 - theta;
%  rotation matrices
ry = @( x ) [ cos( x ), 0, sin( x ); 0, 1, 0; - sin( x ), 0, cos( x ) ];
rz = @( x ) [ cos( x ), - sin( x ), 0; sin( x ), cos( x ), 0; 0, 0, 1 ];

%  rotation function
fun = @( phi, theta, scale ) scale * verts * ry( - theta ) * rz( - phi );
%  apply rotation and scaling
verts = arrayfun( fun, phi, theta, scale, 'UniformOutput', false );

%  transform positions to cell array
pos = mat2cell( pos, ones( size( pos, 1 ), 1 ), 3 );
%  displacement function
fun = @( verts, pos ) bsxfun( @plus, verts, pos );
%  apply displacement
verts = cellfun( fun, verts, pos, 'UniformOutput', false );

%  make list of vertices
verts = cell2mat( verts( : ) );
%  make list of faces
faces = arrayfun( @( i ) faces + i * nverts,  ...
                      0 : ( numel( len ) - 1 ), 'UniformOutput', false );
faces = cell2mat( faces( : ) ); 

%  color data
cdata = reshape( ones( nverts, 1 ) * reshape( len, 1, [] ), [], 1 );

h = patch( struct( 'vertices', verts, 'faces', faces ),  ... 
   'EdgeColor', 'none', 'FaceColor', 'interp', 'FaceVertexCData', cdata ); 
 
     