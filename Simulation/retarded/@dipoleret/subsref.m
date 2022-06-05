function varargout = subsref( obj, s )
%  Class properties and derived properties for dipoleret objects.
%
%  Usage for obj = dipoleret :
%    obj.pt                 :  acces to point property
%    obj.dip                :  orientation of dipole moments
%    obj( p, enei )         :  external potential for use in bemstat
%    obj.field( p, enei )   :  electric field
%    obj.decayrate( sig )   :  total and radiative decay rate
%    obj.scattering( sig )  :  total and differential scattering cross section

switch s( 1 ).type
  %  electric field and light polarization  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field( obj, s( 2 ).subs{ : } );
      case 'decayrate'
        [ varargout{ 1 : nargout } ] = decayrate( obj, s( 2 ).subs{ : } );
      case { 'scattering', 'sca' }
        [ varargout{ 1 : nargout } ] = scattering( obj, s( 2 ).subs{ : } );        
      otherwise
        varargout{ 1 } = builtin( 'subsref', obj, s );
    end
    
  %  external potential    
  case '()'
    varargout{ 1 } = potential( obj, s( 1 ).subs{ : } );
end
