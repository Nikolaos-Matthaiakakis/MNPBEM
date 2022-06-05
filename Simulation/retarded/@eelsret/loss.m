function [ psurf, pbulk ] = loss( obj, sig )
%  LOSS - EELS loss probability.
%
%  See Garcia de Abajo et al., PRB 65, 115418 (2002), RMP 82, 209 (2010).
%
%  Usage for obj = eelsret :
%    [ psurf, pbulk ] = loss( obj, sig )
%  Input
%    sig    :  surface charge (from bemret)
%  Output
%    psurf  :  EELS loss probability from surface plasmons
%    pbulk  :  loss probability from bulk material

%  discretized particle boundary
p = obj.p;
%  dielectric functions and wavenumbers
eps = cellfun( @( eps ) ( eps( sig.enei ) ), p.eps );
%  wavenumber of light
k = 2 * pi / sig.enei * sqrt( eps );

%  Lorentz contraction factors
gamma = 1 ./ sqrt( 1 - eps * obj.vel ^ 2 );
%  wavenumber of electron beam
q = 2 * pi / ( sig.enei * obj.vel );

%  initialize array
psurf = zeros( 1, size( obj.impact, 1 ) );
%  auxiliary function for energy loss
fun1 = @( ind ) ( sig.sig1( ind, : ) - obj.vel * squeeze( sig.h1( ind, 3, : ) ) ); 
fun2 = @( ind ) ( sig.sig2( ind, : ) - obj.vel * squeeze( sig.h2( ind, 3, : ) ) ); 

%  potential for beam in embedding medium
phi = obj.vel * ( conj( potinfty(  obj, q, gamma( 1 ) ) ) -  ...
             full( obj, potinside( obj, - q, k( 1 ) ) ) );
%  index to face elements with embedding medium at in- or outside
ind1 = p.index( find( p.inout( :, 1 ) == 1 )' );
ind2 = p.index( find( p.inout( :, 2 ) == 1 )' );
%  add contributions to energy loss
if ~isempty( ind1 )
  psurf = psurf - imag( p.area( ind1 )' * ( phi( ind1, : ) .* fun1( ind1 ) ) );
end
if ~isempty( ind2 )
  psurf = psurf - imag( p.area( ind2 )' * ( phi( ind2, : ) .* fun2( ind2 ) ) );
end

%  loop over materials
for mat = setdiff( unique( p.inout( : )' ), 1 )
  %  index to face elements with embedding medium at in- or outside
  ind1 = p.index( find( p.inout( :, 1 ) == mat )' );
  ind2 = p.index( find( p.inout( :, 2 ) == mat )' );
  %  potential for beam inside of given medium
  phi = obj.vel * full( obj,  ...
      potinside( obj, - q, k( mat ), find( any( p.inout == mat, 2 ) )', mat ) );
  %  add contributions to energy loss
  if ~isempty( ind1 )
    psurf = psurf - imag( p.area( ind1 )' * ( phi( ind1, : ) .* fun1( ind1 ) ) );
  end
  if ~isempty( ind2 )
    psurf = psurf - imag( p.area( ind2 )' * ( phi( ind2, : ) .* fun2( ind2 ) ) );   
  end
end

%  load atomic units
misc.atomicunits;
%  surface plasmon loss [PRB, Eq. (28)]
psurf = fine ^ 2 / ( bohr * hartree * pi * obj.vel ) * psurf;
%  bulk losses
pbulk = bulkloss( obj, sig.enei );

