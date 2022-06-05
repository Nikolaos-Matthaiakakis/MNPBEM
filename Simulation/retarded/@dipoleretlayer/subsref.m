function varargout = subsref( obj, s )
%  Class properties and derived properties for DIPOLERETLAYER objects.
%
%  Usage for obj = dipoleretlayer :
%    obj.pt                 :  acces to point property
%    obj.dip                :  orientation of dipole moments
%    obj( p, enei )         :  external potential for use in bemstat
%    obj.field( p, enei )   :  electric field
%    obj.decayrate(  sig )  :  total and radiative decay rates
%    obj.decayrat0( enei )  :  decay rates for layer structure

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case 'layer'
        varargout{ 1 } = builtin( 'subsref', obj, s );
      case 'field'
        varargout{ 1 } = field( obj, s( 2 ).subs{ : } );
      case 'decayrate'
        [ varargout{ 1 : nargout } ] = decayrate(  obj, s( 2 ).subs{ : } );
     case 'decayrate0'
        [ varargout{ 1 : nargout } ] = decayrate0( obj, s( 2 ).subs{ : } );        
      otherwise
        [ varargout{ 1 : nargout } ] = subsref( obj.dip, s );
    end
  case '()'
    varargout{ 1 } = potential( obj, s( 1 ).subs{ : } );
end
