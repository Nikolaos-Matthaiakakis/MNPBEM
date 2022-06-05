function obj = init2( obj, val, truecolor )
%  Initialization of VALARRAY.
%
%  Usage for obj = valarray :
%    obj = init2( obj, val )
%    obj = init2( obj, val, 'truecolor' )
%    obj = init2( obj, [],  'truecolor' )
%  Input
%    val  :  value array

if ~isempty( val )
  %  expand to full size or interpolate from faces to vertices
  if size( val, 1 ) == 1,        val = repmat( val, obj.p.nverts, 1 );  end
  if size( val, 1 ) == obj.p.n,  val = interp( obj.p, val );            end
  %  save value array
  obj.val = val;
  if exist( 'truecolor', 'var' )
    obj.truecolor = true;  
  else
    obj.truecolor = false; 
  end
else
  %  set default values
  [ obj.val, obj.truecolor ] =  ...
             deal( repmat( [ 1, 0.7, 0 ], obj.p.nverts, 1 ), true );
end
