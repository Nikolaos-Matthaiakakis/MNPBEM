function varargout = plot( obj, varargin )
%  PLOT - Plot discretized particle surface or values given on surface.
%
%  Usage for obj = particle :
%    plot( obj,      'PropertyName', PropertyValue, ... )
%    plot( obj, val, 'PropertyName', PropertyValue, ... )
%  Input
%    val            :  value array
%  PropertyName
%    EdgeColor      :  color of edges of surface elements
%    FaceAlpha      :  transparency of surface elements
%    FaceColor      :  nfaces x 3 vector of RGB colors
%    nvec           :  plot normal vetors or not (1 and 0)
%    vec            :  vector or vector array to be plotted
%    cone           :  vector or vector array to be plotted (cone plot)
%    color          :  color of vectors
%    fun            :  plot function
%    scale          :  sale factor for vectors
%    sfun           :  scale length of cones with given function

%  handle different calling sequences
if isempty( varargin ) || ischar( varargin{ 1 } )
  val = [];
else
  [ val, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  get BEMPLOT object
h = bemplot.get( varargin{ : } );
%  extract input
op = getbemoptions( varargin{ : } );

%  plot value array 
if     isempty( val ) && ~isfield( op, 'FaceColor' )
  h = plottrue( h, obj, val, varargin{ : } );
elseif isempty( val ) &&  isfield( op, 'FaceColor' )
  h = plottrue( h, obj, op.FaceColor, varargin{ : } );
else
  h = plotval(  h, obj, val, varargin{ : } );
end

%  plot edges
if isfield( op, 'EdgeColor' )
  hold on;
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
  h = plotarrow( h, obj.pos, obj.vec{ 3 }, varargin{ : } );  
end
%  plot vectors and cones
if isfield( op, 'vec'  ),  h = plotarrow( h, obj.pos, op.vec,  varargin{ : } );  end
if isfield( op, 'cone' ),  h =  plotcone( h, obj.pos, op.cone, varargin{ : } );  end

%  set output
[ varargout{ 1 : nargout } ] = deal( h );
%  plot options
lighting phong;  
shading interp;

