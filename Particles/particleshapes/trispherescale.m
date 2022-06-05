function p = trispherescale( p, scale, unit )
%  TRISPHERESCALE - Deform surface of sphere.

if exist( 'unit', 'var' ) && unit;   scale = scale / max( scale( : ) );  end

%  p is a comparticle
if isa( p, 'comparticle' )
  for i = 1 : length( p.p )
    p.p{ i } = trispherescale( p.p{ i }, scale( p.index( i ) ) );
  end
  p = norm( p );
%  p is a particle
else
  if length( scale ) == p.nfaces;  scale = interp( p, scale );  end
  p.verts = repmat( scale( : ), 1, 3 ) .* p.verts;
end
