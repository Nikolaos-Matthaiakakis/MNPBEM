function val = subsref( obj, s )
%  Access to class functions and properties, and BEM solver initialization.
%
%  Usage for obj = bemretlayer :
%    obj.field( sig )       :  call     field (see bemretlayer/field)
%    obj.potential( sig )   :  call potential (see bemretlayer/potential)
%    obj = obj( enei )      :  computes resolvent matrices for later use
%                                in mldivide 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case { 'field', 'fieldret' }
        val = field(     obj, s( 2 ).subs{ : } );
      case { 'potential', 'potentialret' }
        val = potential( obj, s( 2 ).subs{ : } );        
      otherwise
        val = builtin( 'subsref', obj, s );
    end  
  %  matrix for BEM solution        
  case '()'
    %  energy
    enei = cell2mat( s.subs ); 
    val = initmat( obj, enei ); 
end
