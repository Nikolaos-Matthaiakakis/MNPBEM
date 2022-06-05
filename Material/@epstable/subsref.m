function varargout = subsref( obj, s )
%  Interpolate tabulated dielectric function and wavenumber in medium.
%
%  Usage for obj = epstable
%    [ eps, k ] = obj( enei )
%  Input
%    enei   :  light wavelength in vacuum
%  Output
%    eps    :  interpolated dielectric function
%    k      :  wavenumber in medium

switch s.type
  case '.'
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );  
  case '()'
   %  light wavelength (nm)
   enei = s.subs{ 1 };
   %  assert that energy is in range
   assert( min( enei ) >= min( obj.enei ) &&  ...
           max( enei ) <= max( obj.enei ) );
   %  real and imaginary part of refractive index
   ni = ppval( obj.ni, enei );
   ki = ppval( obj.ki, enei );
   %  dielectric function
   eps = ( ni + 1i * ki ) .^ 2;
   %  wavenumber
   k = 2 * pi ./ enei .* sqrt( eps );
   
   %  set output
   varargout{ 1 } = eps;
   varargout{ 2 } = k;
end
 