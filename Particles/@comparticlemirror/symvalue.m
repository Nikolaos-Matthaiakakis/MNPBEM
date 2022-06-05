function val = symvalue( obj, key )
%  SYMVALUE - Symmetry values for given key.
%
%  Usage for obj = comparticlemirror :
%    val = obj.symvalue( key )
%  Input
%    key    :  '+', '-' for sym = { 'x', 'y' }, and
%              '++', '+-', '-+', '--' for sym = 'xy'
%  Output
%    val    :  value array

if iscell( key )
  val = [];
  for i = 1 : length( key )
    val = [ val; symvalue( obj, key{ i } ) ];
  end
else
  switch key
    case '+'
      val = [ 1,   1 ];
    case '-'
      val = [ 1, - 1 ];
    case '++'
      val = [ 1,   1,   1,   1 ];
    case '+-'
      val = [ 1,   1, - 1, - 1 ];
    case '-+'
      val = [ 1, - 1,   1, - 1 ];
    case '--'
      val = [ 1, - 1, - 1,   1 ];
  end
end
