function field = field( obj, sig, inout )
%  Electric field inside/outside of particle surface.
%
%  Usage for obj = bemstat :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  COMPSTRUCT object with surface charges 
%    inout      :  electric field inside (inout = 1) or
%                                outside (inout = 2, default) of particle
%  Output
%    field      :  COMPSTRUCT object with electric field

if ~exist( 'inout', 'var' ),  inout = 2;  end

%  compute field from derivative of Green function or from potential
%  interpolation
switch obj.g.deriv
  case 'cart'
    field = obj.g.field( sig, inout );
    
  case 'norm'
    %  One can additionally compute the electric fields using only the
    %  surface derivatives and interpolating the potentials and performing
    %  numerical derivatives for the tangential derivatives within the
    %  boundary elements, however, the results seem to be less accurate.

    %  electric field in normal direction
    switch inout
      case 1
        e = - outer( obj.p.nvec, matmul( obj.g.H1, sig.sig ) );
      case 2
        e = - outer( obj.p.nvec, matmul( obj.g.H2, sig.sig ) );
    end

    %  tangential directions of electric field are computed by
    %  interpolation of potential to vertices and performing an approximate
    %  tangential derivative
    phi = interp( obj.p, matmul( obj.g.G, sig.sig ) );
    %  derivatives of function along tangential directions
    [ phi1, phi2, t1, t2 ] = deriv( obj.p, phi );

    %  normal vector
    nvec = cross( t1, t2 );
    %  decompose into norm and unit vector
    h = sqrt( dot( nvec, nvec, 2 ) );  nvec = bsxfun( @rdivide, nvec, h );

    %  tangential derivative of PHI
    phip = outer( bsxfun( @rdivide, cross( t2, nvec, 2 ), h ), phi1 ) -  ...
           outer( bsxfun( @rdivide, cross( t1, nvec, 2 ), h ), phi2 );
    %  add electric field in tangential direction
    e = e - phip;

    %  set output
    field = compstruct( obj.p, sig.enei, 'e', e );
end
