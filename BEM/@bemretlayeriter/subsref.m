function varargout = subsref( obj, s )
%  Access to class functions and properties, and BEM solver initialization.
%
%  Usage for obj = bemretlayeriter :
%    obj.field( sig )       :  electromagnetic fields
%    obj.potential( sig )   :  electromagnetic potentials
%    obj = obj( enei )      :  initialize Green functions and preconditioner 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } );   
      case 'clear'
        varargout{ 1 } = clear( obj );        
      otherwise
        varargout{ 1 } = builtin( 'subsref', obj, s );
    end  
  %  initialize BEM solver and preconditioner         
  case '()'
    %  light wavelength in vacuum
    enei = cell2mat( s.subs ); 
    varargout{ 1 } = initmat( obj, enei ); 
end
