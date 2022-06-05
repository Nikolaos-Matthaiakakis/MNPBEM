function obj = plot( obj, opt, varargin )
%  PLOT - Plot vector array.
%
%  Usage for obj = vecarray :
%    obj = plot( obj, opt )
%  Input
%    opt            :  plot options

%  get vector array
vec = subsref( obj, substruct( '()', { opt } ) );
%  vector length
len = vecnorm( vec );  
%  apply scaling function and scaling factor
if opt.scale > 0
  scale =   opt.scale * opt.sfun( len / max( len ) );
else
  scale = - opt.scale * opt.sfun( len );
end

%  delete previous plot
if ~isempty( obj.h ), delete( obj.h );  end
%  new plot
switch obj.mode
  case 'cone'
    %  cone plot
    obj.h = coneplot( obj.pos, vec, len, scale );
  case 'arrow'
    %  extract options
    op = getbemoptions( varargin{ : } );
    %  get color
    if isfield( op, 'color' ),  obj.color = op.color;  end
    %  scale vector plot
    vec = bsxfun( @times, vec, scale );
    %  quiver plot
    hold on;
    obj.h = quiver3( obj.pos( :, 1 ), obj.pos( :, 2 ), obj.pos( :, 3 ),  ...
                vec( :, 1 ), vec( :, 2 ), vec( :, 3 ), 'color', obj.color );
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
   'FaceVertexCData', cdata, 'FaceColor', 'interp', 'EdgeColor', 'none' ); 
 
lighting phong;  
shading interp;
     