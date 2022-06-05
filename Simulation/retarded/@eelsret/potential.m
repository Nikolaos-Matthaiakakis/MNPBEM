function exc = potential( obj, enei )
%  POTENTIAL - Potential of electron beam excitation for use in bemret.
%
%  See F. J. Garcia de Abajo & A. Howie, Phys. Rev. B 65, 115418 (2002). 
%
%  Usage for obj = eelsret :
%    exc = potential( obj, enei )
%  Input
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  COMPSTRUCT array which contains the scalar and vector
%                  potentials, as well as their surface derivatives

%  discretized particle boundary
p = obj.p;
%  dielectric functions and wavenumbers
eps = cellfun( @( eps ) ( eps( enei ) ), p.eps );

%  Lorentz contraction factors
gamma = 1 ./ sqrt( 1 - eps * obj.vel ^ 2 );
%  wavenumber of electron beam
q = 2 * pi / ( enei * obj.vel );

%%  allocate compstruct for excitation
%  external excitation
exc = compstruct( p, enei );
%  number of impact parameters
n = size( obj.impact, 1 );
%  allocate arrays for scalar potential
exc.phi1 = zeros( p.n, n );  exc.phi1p = zeros( p.n, n );
exc.phi2 = zeros( p.n, n );  exc.phi2p = zeros( p.n, n );
%  allocate arrays for vector potential
exc.a1 = zeros( p.n, 3, n );  exc.a1p = zeros( p.n, 3, n );
exc.a2 = zeros( p.n, 3, n );  exc.a2p = zeros( p.n, 3, n );

%%  excitation of embedding medium
%  index to face elements with embedding medium at in- or outside
ind = find( any( p.inout == 1, 2 )' );
%  potential and surface derivative for infinite beam
[ phi, phip ] = potinfty( obj, q, gamma( 1 ), ind );

%  add to external potential
exc = addpotential( exc, p, phi, phip, 1, eps( 1 ), obj.vel );

%%  excitation to other media
for mat = setdiff( unique( p.inout( : )' ), 1 )
    
  %  index to face elements with given medium at in- or outside  
  ind = find( any( p.inout == mat, 2 )' );
  %  potential and surface derivative for beam inside of material
  [ phi, phip ] = potinfty( obj, q, gamma( mat ), ind, mat );
  %  add to external potential
  if ~all( phi == 0 )
    exc = addpotential( exc, p, phi, phip, mat, eps( mat ), obj.vel );  
  end
end


function exc = addpotential( exc, p, phi, phip, mat, eps, vel )
%  ADDPOTENTIAL - Add potential to external excitation.
%
%  Input
%    exc    :  compstruct object for external potential
%    p      :  particle object
%    phi    :  scalar potential
%    phip   :  surface derivative of scalar potential 
%    mat    :  index to medium
%    eps    :  dielectric function
%    vel    :  electron beam velocity in units of speed of light

%  vector potential and surface derivative [Eq. (25)]
a  = vel * outer( repmat( [ 0, 0, 1 ], p.n, 1 ), phi  );
ap = vel * outer( repmat( [ 0, 0, 1 ], p.n, 1 ), phip );
%  scalar potential and surface derivative
[ phi, phip ] = deal( phi / eps, phip / eps );

%  index to inner and outer surface elements
ind1 = p.index( find( p.inout( :, 1 ) == mat )' );
ind2 = p.index( find( p.inout( :, 2 ) == mat )' );

%  add to compstruct object
exc.phi1(  ind1, : ) = exc.phi1(  ind1, : ) + phi(  ind1, : );
exc.phi1p( ind1, : ) = exc.phi1p( ind1, : ) + phip( ind1, : );
exc.a1(    ind1, : ) = exc.a1(    ind1, : ) + a(    ind1, : );
exc.a1p(   ind1, : ) = exc.a1p(   ind1, : ) + ap(   ind1, : );

exc.phi2(  ind2, : ) = exc.phi2(  ind2, : ) + phi(  ind2, : );
exc.phi2p( ind2, : ) = exc.phi2p( ind2, : ) + phip( ind2, : );
exc.a2(    ind2, : ) = exc.a2(    ind2, : ) + a(    ind2, : );
exc.a2p(   ind2, : ) = exc.a2p(   ind2, : ) + ap(   ind2, : );
