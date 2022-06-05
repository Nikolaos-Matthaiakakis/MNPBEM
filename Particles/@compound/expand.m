function full = expand( obj, val )
%  EXPAND - Expand cell array for all point or particle positions.
%
%  Usage for obj = compound :
%    full = expand( obj, val )

siz = cellfun( @( p ) ( p.size ), obj.p( obj.mask ) );

if ~iscell( val )
  full = repmat( val, sum( siz ), 1 );
else
  full = [];
  for i = 1 : length( siz )
    full = [ full; repmat( val{ i }, siz( i ), 1 ) ];
  end
end