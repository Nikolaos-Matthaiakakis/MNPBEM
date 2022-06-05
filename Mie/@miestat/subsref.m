function varargout = subsref( obj, s )
%  Class properties and derived properties for MIESTAT objects.
%
%  Usage for obj = miestat :
%    obj.scattering( enei )    :  scattering cross section 
%    obj.absorption( enei )    :  absorption cross section
%    obj.extinction( enei )    :  extinction cross section 
%    obj.decayrate( enei, z )  :  total and radiative decay rate for dipole
%    obj.loss( varargin )      :  EELS loss probability


switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case { 'sca', 'scattering' }
        varargout{ 1 } = scattering( obj, s( 2 ).subs{ : } );
      case { 'abs', 'absorption' }
        varargout{ 1 } = absorption( obj, s( 2 ).subs{ : } );
      case { 'ext', 'extinction' }
        varargout{ 1 } = extinction( obj, s( 2 ).subs{ : } );
      case 'decayrate'
        [ varargout{ 1 : nargout } ] = decayrate( obj, s( 2 ).subs{ : } );
      case 'loss'
        [ varargout{ 1 : nargout } ] = loss( obj, s( 2 ).subs{ : } );        
      otherwise
        varargout{ 1 } = builtin( 'subsref', obj, s );
    end
    
end
