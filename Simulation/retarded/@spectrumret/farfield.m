function [ field, k ] = farfield( obj, sig, dir )
%  FARFIELD - Electromagnetic fields of surface charge distribution.
%    F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010), Eq. (50).
%
%  Usage for obj = spectrumret :
%    field = farfield( obj, sig, dir )
%  Input
%    sig    :  surface charge distribution
%    dir    :  light propagation direction 
%                (surface normals of unit sphere on default )
%  Output
%    field  :  compstruct object that holds scattered far-fields
%    k      :  wavenumber of light in medium

if ~exist( 'dir', 'var' );  dir = obj.pinfty.nvec;  end

%%  extract input
%  particle surface
p = sig.p;
%  wavenumber of light in medium
[ ~, k ] = p.eps{ obj.medium }( sig.enei );
%  wavenumber of light in vacuum
k0 = 2 * pi / sig.enei;

%%  far-fields of surface charge distribution
e = 0;
h = 0;
%  direction for cross product
idir = repmat( reshape( dir, [ size( dir ), 1 ] ),  ...
                            [ 1, 1, size( sig.h1( :, :, : ), 3 ) ] );
%  phase factor
phase = exp( - 1i * k * dir * p.pos' ) * spdiag( p.area );
                          
%%  contribution from inner surface
ind = p.index( find( p.inout( :, 1 ) == obj.medium )' ); 

if ~isempty( ind )
  e = 1i * k0 * matmul( phase( :, ind ), sig.h1(   ind, :, : ) ) -  ...
      1i * k  *  outer( dir, matmul( phase( :, ind ),               ...
                                          sig.sig1( ind, : ) ) );
  %  magnetic field
  h = 1i * k * cross( idir,  ...
              matmul( phase( :, ind ), sig.h1( ind, :, : ) ), 2 );
end

%%  contribution from outer surface
ind = p.index( find( p.inout( :, 2 ) == obj.medium )' );

if ~isempty( ind )
  %  electric field
  e = e + 1i * k0 * matmul( phase( :, ind ), sig.h2(   ind, :, : ) ) -  ...
          1i * k  *  outer( dir, matmul( phase( :, ind ),               ...
                                              sig.sig2( ind, : ) ) );                                            
  %  magnetic field
  h = h + 1i * k * cross( idir,  ...
                  matmul( phase( :, ind ), sig.h2( ind, :, : ) ), 2 );
end

%  make compstruct object
try
  field = compstruct(  ...
    comparticle( sig.p.eps, { obj.pinfty }, obj.medium ), sig.enei );
catch
  field = compstruct( obj.pinfty, sig.enei );
end
%  reshape far-field
siz = size( sig.h2 );
if numel( e ) == 1 && e == 0
  field.e = zeros( [ size( dir, 1 ), siz( 2 : end ) ] );
  field.h = zeros( [ size( dir, 1 ), siz( 2 : end ) ] );
else
  field.e = reshape( e, [ size( dir, 1 ), siz( 2 : end ) ] );
  field.h = reshape( h, [ size( dir, 1 ), siz( 2 : end ) ] );
end
