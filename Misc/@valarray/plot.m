function obj = plot( obj, opt, varargin )
%  PLOT - Plot value array.
%
%  Usage for obj = valarray :
%    obj = plot( obj, opt, PropertyPairs )
%  Input
%    opt            :  plot options
%  PropertyName
%    'FaceAlpha'    :  alpha value of faces

%  get value array
val = subsref( obj, substruct( '()', { opt } ) );
%  get options
op = getbemoptions( varargin{ : } );

if isempty( obj.h )
  %  default value for FaceAlpha
  if ~isfield( op, 'FaceAlpha' ),  op.FaceAlpha = 1;  end
  
  obj.h = patch(  ...
      struct( 'vertices', obj.p.verts, 'faces', obj.p.faces ),  ...
      'FaceVertexCData', val, 'FaceColor', 'interp',            ...
      'EdgeColor', 'none', 'FaceAlpha', op.FaceAlpha );
else
  set( obj.h, 'FaceVertexCData', val );
  if isfield( op, 'FaceAlpha' ),  set( obj.h, 'FaceAlpha', op.FaceAlpha );  end
end
