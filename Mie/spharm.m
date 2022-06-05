function  y = spharm( ltab, mtab, theta, phi )
% SPHARM - Spherical harmonics.
%
%  Usage : 
%    y = spharm( ltab, mtab, theta, phi )
%  Input
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%    theta  :  polar angle
%    phi    :  azimuthal angle
%  Output
%    y      :  spherical harmonic
persistent factab;

%  table of factorials ( used for speedup )
if ( max( ltab + abs( mtab ) + 1 ) > length( factab ) )
  %  clear FACTAB
  factab = [];
  for i = 0 : max( ltab + abs( mtab ) ) + 1
    factab = [ factab, factorial( i ) ];
  end
end


%  convert to column and row vectors
ltab  = ltab(  : );  
mtab  = mtab(  : );  
theta = theta( : )';  
phi   = phi(   : )';

%  dimension arrays
y  = zeros( length( ltab ), length( theta ) );

%  loop over unique ltab values
for l = unique( ltab )'
    
  %  full table of Legendre functions
  ptab = legendre( l, cos( theta ) );
  
  %  index to entries with degree ll
  index = find( ltab == l );
  %  index to allowed entries  abs( m ) <= l
  index = index( abs( mtab( index ) ) <= l );
  
  for i = index'
    %  corresponding spherical order (only absolute value considered first)
    m = mtab( i );
    %  prefactor for spherical harmonics
    c = sqrt( ( 2 * l + 1 ) / ( 4 * pi ) *  ...
        factab( l - abs( m ) + 1 ) / factab( l + abs( m ) + 1 ) );
    %  spherical harmonics
    y( i, : ) = c * ptab( abs( m ) + 1, : ) .* exp( 1i * abs( m ) * phi );
    %  correct for negative orders
    if ( m < 0 )
      y( i, : ) = ( - 1 ) ^ m * conj( y( i, : ) );
    end
  end    
  
end
