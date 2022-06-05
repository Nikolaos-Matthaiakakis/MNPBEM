function varargout = subsref( obj, s )
%  Drude dielectric function and wavenumber in medium.
%
%  Usage for obj = epsdrude
%    [ eps, k ] = obj( enei )
%  Input
%    enei   :  light wavelength in vacuum (nm)
%  Output
%    eps    :  Drude dielectric function
%    k      :  wavenumber in medium

switch s.type
  case '.'
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );  
  case '()'
    units;
    %  light wavelength in vacuum
    enei = s( 1 ).subs{ 1 };
    %  convert to eV
    w = eV2nm ./ enei;
    %  dielectric function and wavevector
    eps = obj.eps0 - obj.wp ^ 2 ./ ( w .* ( w + 1i * obj.gammad ) );
    %  wavenumber
    k = 2 * pi ./ enei .* sqrt( eps );
     
    %  set output
    varargout{ 1 } = eps;
    varargout{ 2 } = k;
end
