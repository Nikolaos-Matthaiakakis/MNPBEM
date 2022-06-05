function exc = field( obj, p, enei, varargin )
%  FIELD - Electric field for dipole excitation.
%
%  Usage for obj = dipoleretlayer :
%    exc = field( obj, enei )
%    exc = field( obj, enei,        'refl' )
%    exc = field( obj, enei, inout         )
%    exc = field( obj, enei, inout, 'refl' )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%    inout      :  compute field at in- or out-side of p (inout = 1 on default)
%    'refl'     :  compute only reflected part of electric dipole field
%  Output
%    exc        :  COMPSTRUCT object which contains the electromagnetic 
%                  fields, the last two dimensions of exc.e correspond to
%                  the positions and dipole moments

%  extract input
if ~isempty( varargin ) && isnumeric( varargin{ 1 } ),  inout = varargin{ 1 };  end
if ~isempty( varargin ) && ischar(  varargin{ end } ),  key = varargin{ end };  end
%  default value for inout
if ~exist( 'inout', 'var' ),  inout = 1;  end

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  direct excitation
if ~exist( 'key', 'var' ) || ~strcmp( key, 'refl' )
  exc = field( obj.dip, p, enei, inout ); 
else
  %  external excitation
  exc = compstruct( p, enei );
  %  dipole moments
  dip = obj.dip.dip;
  %  allocate arrays for electromagnetic fields
  exc.e = zeros( p.n, 3, size( dip, 1 ), size( dip, 3 ) );
  exc.h = zeros( p.n, 3, size( dip, 1 ), size( dip, 3 ) ); 
end

%  find particle positions connected to layer structure
ind1 = any( bsxfun( @eq, p.expand( num2cell( p.inout( :, end ) ) ), obj.layer.ind ), 2 );
%  positions of particle surface where potential is computed
pos1 = p.pos( ind1, : );

%  dipole positions and dipole moments
[ pt, dip ] = deal( obj.dip.pt, obj.dip.dip );
%  find dipole positions connected to layer structure
ind2 = any( bsxfun( @eq, pt.expand( pt.inout ), obj.layer.ind ), 2 );
%  positions of dipoles
pos2 = pt.pos( ind2, : );
%  dielectric function of media where dipoles are embedded
eps2 = pt.eps2( enei );  eps2 = eps2( ind2 );

%  evaluate Green function table
obj.tab = eval( obj.tab, enei );
%  Green functions and their derivatives 
[ G, F ] = greenderiv( obj, pos1, pos2 );
%  dipole moment reduced by dielectric function
dip2 = matmul( diag( 1 ./ eps2 ), dip );
     
%%  potentials
%  vector potential
a1 = - 1i * k0 * fun(         G.p,  dip(  ind2, 1, : ) ); 
a2 = - 1i * k0 * fun(         G.p,  dip(  ind2, 2, : ) );
a3 = - 1i * k0 * fun(         G.hh, dip(  ind2, 3, : ) )  ...
               + fun( F{ 1, 2 }.hs, dip2( ind2, 1, : ) )  ...
               + fun( F{ 1, 3 }.hs, dip2( ind2, 2, : ) )  ...
               + fun( F{ 1, 4 }.hs, dip2( ind2, 3, : ) );
   
%  size of vector potential
siz = size( exc.e( ind1, 1, ind2, : ) );
%  vector potential part of  E = 1i * k0 * A - grad V
exc.e( ind1, 1, ind2, : ) = exc.e( ind1, 1, ind2, : ) + 1i * k0 * reshape( a1, siz );
exc.e( ind1, 2, ind2, : ) = exc.e( ind1, 2, ind2, : ) + 1i * k0 * reshape( a2, siz );
exc.e( ind1, 3, ind2, : ) = exc.e( ind1, 3, ind2, : ) + 1i * k0 * reshape( a3, siz );

%%  derivatives of potentials

%  vector potential derivatives \partial_2 A_3 - \partial_3 A_2
a23 = - 1i * k0 * fun( F{ 3, 1 }.hh, dip(  ind2, 3, : ) )  ...
                + fun( F{ 3, 2 }.hs, dip2( ind2, 1, : ) )  ...
                + fun( F{ 3, 3 }.hs, dip2( ind2, 2, : ) )  ...
                + fun( F{ 3, 4 }.hs, dip2( ind2, 3, : ) );
a32 = - 1i * k0 * fun( F{ 4, 1 }.p,  dip(  ind2, 2, : ) );  
%  vector potential derivatives \partial_3 A_1 - \partial_1 A_3
a31 = - 1i * k0 * fun( F{ 4, 1 }.p, dip(   ind2, 1, : ) );  
a13 = - 1i * k0 * fun( F{ 4, 1 }.hh, dip(  ind2, 3, : ) )  ...
                + fun( F{ 4, 2 }.hs, dip2( ind2, 1, : ) )  ...
                + fun( F{ 4, 3 }.hs, dip2( ind2, 2, : ) )  ...
                + fun( F{ 4, 4 }.hs, dip2( ind2, 3, : ) );
%  vector potential derivatives \partial_1 A_2 - \partial_2 A_1
a12 = - 1i * k0 * fun( F{ 2, 1 }.p, dip(  ind2, 2, : ) );
a21 = - 1i * k0 * fun( F{ 3, 1 }.p, dip(  ind2, 1, : ) );

%  \partial_1 V
phi1 =         + fun( F{ 2, 2 }.ss, dip2( ind2, 1, : ) )  ...
               + fun( F{ 2, 3 }.ss, dip2( ind2, 2, : ) )  ...
               + fun( F{ 2, 4 }.ss, dip2( ind2, 3, : ) )  ...
     - 1i * k0 * fun( F{ 2, 1 }.sh, dip(  ind2, 3, : ) );
%  \partial_2 V   
phi2 =         + fun( F{ 3, 2 }.ss, dip2( ind2, 1, : ) )  ...
               + fun( F{ 3, 3 }.ss, dip2( ind2, 2, : ) )  ...
               + fun( F{ 3, 4 }.ss, dip2( ind2, 3, : ) )  ...
     - 1i * k0 * fun( F{ 3, 1 }.sh, dip(  ind2, 3, : ) );
%  \partial_3 V
phi3 =         + fun( F{ 4, 2 }.ss, dip2( ind2, 1, : ) )  ...
               + fun( F{ 4, 3 }.ss, dip2( ind2, 2, : ) )  ...
               + fun( F{ 4, 4 }.ss, dip2( ind2, 3, : ) )  ...
     - 1i * k0 * fun( F{ 1, 4 }.sh, dip(  ind2, 3, : ) );
   
   
%  scalar potential part of  E = 1i * k0 * A - grad V
exc.e( ind1, 1, ind2, : ) = exc.e( ind1, 1, ind2, : ) - reshape( phi1, siz );
exc.e( ind1, 2, ind2, : ) = exc.e( ind1, 2, ind2, : ) - reshape( phi2, siz );
exc.e( ind1, 3, ind2, : ) = exc.e( ind1, 3, ind2, : ) - reshape( phi3, siz );
%  magnetic field
exc.h( ind1, 1, ind2, : ) = exc.h( ind1, 1, ind2, : ) - reshape( a23 - a32, siz );
exc.h( ind1, 2, ind2, : ) = exc.h( ind1, 2, ind2, : ) - reshape( a31 - a13, siz );
exc.h( ind1, 3, ind2, : ) = exc.h( ind1, 3, ind2, : ) - reshape( a12 - a21, siz );


function y = fun( g, dip )
%  FUN - Multiplication function

%  size of matrices
siz1 = size(   g );
siz2 = size( dip );
%  set output
y = repmat( reshape(   g, [ siz1, 1 ] ), [ 1, 1, siz2( end ) ] ) .*  ...
    repmat( reshape( dip, [ 1, siz2( 1 ), siz2( end ) ] ), [ siz1( 1 ), 1, 1 ] );

