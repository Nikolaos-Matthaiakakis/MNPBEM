function exc = field( obj, p, enei, inout )
%  Electric and magnetic field for plane wave excitation.
%
%  Usage for obj = planewaveret :
%    exc = field( obj, p, enei, inout )
%  Input
%    p          :  points or particle surface where fields are computed
%    enei       :  light wavelength in vacuum
%    inout      :  compute fields at inner (inout = 1, default) or
%                  outer (inout = 2) surface
%  Output
%    exc        :  compstruct object which contains the electric and 
%                  magnetic fields

%%  auxiliary quantities

%  refractive index
nb = sqrt( p.eps{ obj.medium }( enei ) ); 
%  wavenumbers
k0 = 2 * pi / enei;
k  = k0 * nb;
%  light polarization and propagation direction
pol = obj.pol;
dir = obj.dir;
%  assert that polarization and light propagation direction are orthogonal
assert( ~any( dot( pol, dir, 2 ) ) );

if ~exist( 'inout', 'var' );  inout = 1;  end

%%  index to excited faces 
ind = find( p.inout( :, inout ) == obj.medium );
ind = cell2mat(  ...
    arrayfun( @( i ) ( p.index( i ) ), ind, 'UniformOutput', false ) );
ind = ind( : );

%%  fields
e  = zeros( p.n, 3, size( pol, 1 ) );
h  = zeros( p.n, 3, size( pol, 1 ) );  

for i = 1 : size( pol, 1 )
  phase = exp( 1i * k * p.pos( ind, : ) * dir( i, : )' ) / ( 1i * k0 );
  %  electric and magnetic field
  e( ind, :, i ) = 1i * k0 * phase * pol( i, : );
  h(  : , :, i ) = nb *  ...
      cross( repmat( dir( i, : ), p.n, 1 ), e( :, :, i ), 2 );
end

%%  save field
exc = compstruct( p, enei, 'e', e, 'h', h );
