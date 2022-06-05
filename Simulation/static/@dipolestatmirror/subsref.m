function varargout = subsref( obj, s )
%  Class properties and derived properties for DIPOLESTATMIRROR objects.
%
%  Usage for obj = dipolestatmirror :
%    obj( p, enei )         :  external potential 
%    obj.field( p, enei )   :  electric field
%    obj.full( val )        :  expand COMPSTRUCTMIRROR object for full particle
%    obj.decayrate( sig )   :  total decay rate

switch s( 1 ).type 
  case '.'  
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field( obj, s( 2 ).subs{ : } );
      case 'decayrate'
        [ varargout{ 1 : nargout } ] = decayrate( obj, s( 2 ).subs{ : } );
      case 'full'
        varargout{ 1 } = full( obj, s( 2 ).subs{ : } );
      otherwise
        varargout{ 1 } = subsref@dipoleret( obj, s );
    end
  case '()'
    varargout{ 1 } = potential( obj, s( 1 ).subs{ : } );
end
