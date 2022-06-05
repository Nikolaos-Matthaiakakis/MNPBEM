function obj = init( obj )
%  Compute depolarization factors for ellipsoid.
%    See e.g. H.C. van de Hulst, Light scattering by small particles, Sec. 6.32.

%%  ellipsoid axes
ax = obj.ax;

%%  integrals
fun1 = vectorize( inline( 'a*b*c/(2*(s+a^2)^1.5*(s+b^2)^0.5*(s+c^2)^0.5)', 's', 'a', 'b', 'c' ) );
fun2 = vectorize( inline( 'a*b*c/(2*(s+a^2)^0.5*(s+b^2)^1.5*(s+c^2)^0.5)', 's', 'a', 'b', 'c' ) );
fun3 = vectorize( inline( 'a*b*c/(2*(s+a^2)^0.5*(s+b^2)^0.5*(s+c^2)^1.5)', 's', 'a', 'b', 'c' ) );

%%  depolarization factors
%  tolerance for integration
tol = 1e-8;

obj.L1 = quad( fun1, 0, 1e5 * max( ax ), tol, [], ax( 1 ), ax( 2 ), ax( 3 ) );
obj.L2 = quad( fun2, 0, 1e5 * max( ax ), tol, [], ax( 1 ), ax( 2 ), ax( 3 ) );
obj.L3 = quad( fun3, 0, 1e5 * max( ax ), tol, [], ax( 1 ), ax( 2 ), ax( 3 ) );
