function varargout = subsref( obj, s )
%  Dielectric constant and wavenumber.
%
%  Usage for obj = epsconst
%    [ eps, k ] = obj( enei )
%  Input
%    enei   :  light wavelength in vacuum
%  Output
%    eps    :  dielectric constant of medium
%    k      :  wavenumber in medium

switch s.type
  case '.'
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );  
  case '()'
    varargout{ 1 } = repmat( obj.eps, size( s( 1 ).subs{ 1 } ) );
    varargout{ 2 } = obj.wavenumber( s( 1 ).subs{ 1 } );
end
