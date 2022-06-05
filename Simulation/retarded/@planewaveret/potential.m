function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of plane wave excitation for use in bemret.
%
%  Usage for obj = planewaveret :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the scalar and vector
%                  potentials, as well as their surface derivatives

exc = compstruct( p, enei );

%%  auxiliary quantities
%  light polarization and propagation direction
pol = obj.pol;
dir = obj.dir;
%  assert that polarization and light propagation direction are orthogonal
assert( ~any( dot( pol, dir, 2 ) ) );

%  refractive index
nb = sqrt( p.eps{ obj.medium }( enei ) ); 
%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  wavenumber in medium
k  = k0 * nb;

%  loop over inside and outside of particle surfaces
for inout = 1 : size( p.inout, 2 )
    
  %%  vector potential
  a  = zeros( p.nfaces, 3, size( pol, 1 ) );
  ap = zeros( p.nfaces, 3, size( pol, 1 ) );

  %  index to excited faces 
  ind = find( p.inout( :, inout ) == obj.medium )';
  ind = cell2mat( arrayfun( @( i ) ( p.index( i ) ), ind, 'uniform', 0 ) );
  %  make sure that some faces are excited
  if ~isempty( ind )
    for i = 1 : size( pol, 1 )
      phase = exp( 1i * k * p.pos( ind, : ) * dir( i, : )' ) / ( 1i * k0 );
      %  vector potential and surface derivative
      a(  ind, :, i ) = phase * pol( i, : );
      ap( ind, :, i ) =   ...
          ( 1i * k .* p.nvec( ind, : ) * dir( i, : )' ) .* phase * pol( i, : );  
    end
  end
  
  %%  save potentials  
  switch inout
    case 1
      exc = set( exc, 'a1', a, 'a1p', ap );
    case 2
      exc = set( exc, 'a2', a, 'a2p', ap );
  end
  
end
