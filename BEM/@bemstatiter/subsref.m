function obj = subsref( obj, s )
%  Access to functions and class properties, and BEM solver initialization.
%
%  Usage for obj = bemstatiter :
%    obj.field( sig )       :  electric field
%    obj.potential( sig )   :  scalar potential
%    obj = obj( enei )      :  computes resolvent matrix for later use
%                                in mldivide 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        obj = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        obj = potential( obj, s( 2 ).subs{ : } );        
      otherwise
        obj = builtin( 'subsref', obj, s );
    end
    
  %  matrix for BEM solution        
  case '()'
    obj = initmat( obj, s.subs{ : } );
end
