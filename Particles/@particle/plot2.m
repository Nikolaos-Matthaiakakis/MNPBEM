function varargout = plot2( obj, varargin )
%  PLOT2 - Plot discretized particle surface or values given on surface.
%
%  Usage for obj = particle :
%    plot2( obj,      'PropertyName', PropertyValue, ... )
%    plot2( obj, val, 'PropertyName', PropertyValue, ... )
%  Input
%    val            :  nfaces x 3 (or nverts x 3 ) value array
%  PropertyName
%    EdgeColor      :  color of edges of surface elements
%    FaceAlpha      :  transparency of surface elements
%    FaceColor      :  nfaces x 3 vector of RGB colors
%    nvec           :  plot normal vetors or not (1 and 0)
%    vec            :  nfaces x 3 vector to be plotted
%    cone           :  nfaces x 3 vector to be plotted (cone plot)
%    color          :  color of vectors
%    scale          :  sale factor for vectors
%    sfun           :  scale length of cones with given function

if isempty( get( 0, 'CurrentFigure' ) )
  new = true; 
else
  new = isempty( get( gcf, 'CurrentAxes' ) );
end

%  handle different calling sequences
if isempty( varargin ) || ischar( varargin{ 1 } )
  val = [ 1.0, 0.7, 0.0 ];
else
  [ val, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  extract input
op = getbemoptions( varargin{ : } );
%  set default values
if ~isfield( op, 'FaceAlpha' ),  op.FaceAlpha = 1;    end
if  isfield( op, 'FaceColor' ),  val = op.FaceColor;  end

if size( val, 1 ) == size( obj.faces, 1 )
  val = interp( obj, val );
elseif size( val, 1 ) ~= size( obj.verts, 1 )
  val = repmat( val, size( obj.verts, 1 ), 1 );
end

%  plot particle
[ varargout{ 1 : nargout } ] =  ...
  patch( struct( 'vertices', obj.verts, 'faces', obj.faces ),  ...
    'FaceVertexCData', val, 'FaceColor', 'interp',             ...
    'EdgeColor', 'none', 'FaceAlpha', op.FaceAlpha );
hold on;
  
%  plot edges
if isfield( op, 'EdgeColor' )
  %  face connections
  net = unique( sort( nettable( obj.faces ), 2 ), 'rows' );
  %  connection function
  fun = @( i ) [ obj.verts( net( :, 1 ), i ),  ...
                 obj.verts( net( :, 2 ), i ), nan( size( net, 1 ), 1 ) ]';
  %  plot connections
  if ischar( op.EdgeColor )
    plot3( fun( 1 ), fun( 2 ), fun( 3 ),          op.EdgeColor );
  else
    plot3( fun( 1 ), fun( 2 ), fun( 3 ), 'Color', op.EdgeColor );
  end
end 

%  plot outer surface normals
if isfield( op, 'nvec' ) && op.nvec
  arrowplot( obj.pos, obj.vec{ 3 }, varargin{ : } );  
end
%  plot vectors and cones
if isfield( op, 'vec'  ),  arrowplot( obj.pos, op.vec,  varargin{ : } );  end
if isfield( op, 'cone' ),  coneplot2( obj.pos, op.cone, varargin{ : } );  end

%  plot options
lighting phong;  
shading interp;

if new
  axis off;  axis equal;  axis fill;
  if isempty( findobj( gcf, 'type', 'light' ) ),  camlight headlight; end   
  view( 1, 40 );
end
