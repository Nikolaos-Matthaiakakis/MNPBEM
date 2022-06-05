function obj = init( obj, p, val, truecolor )
%  Initialization of VALARRAY.
%
%  Usage for obj = valarray :
%    obj = init( obj, p, val )
%    obj = init( obj, p, val, 'truecolor' )
%    obj = init( obj, p, [],  'truecolor' )
%  Input
%    p    :  particle
%    val  :  value array

obj.p = p;

if ~isempty( val )
  %  expand to full size or interpolate from faces to vertices
  if size( val, 1 ) == 1,    val = repmat( val, p.nverts, 1 );  end
  if size( val, 1 ) == p.n,  val = interp( p, val );            end
  %  save value array
  obj.val = val;
  if exist( 'truecolor', 'var' ),  obj.truecolor = true;  end
else
  %  set default values
  [ obj.val, obj.truecolor ] =  ...
             deal( repmat( [ 1, 0.7, 0 ], p.nverts, 1 ), true );
end
