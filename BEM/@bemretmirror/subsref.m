function val = subsref( obj, s )
%  Access to class functions and properties, and BEM solver initialization.
%
%  Usage for obj = bemretmirror :
%    obj.field( sig )       :  call field
%    obj.potential( sig )   :  call potential
%    obj = obj( enei )      :  computes resolvent matrices for later use
%                                in mldivide 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case 'field'
        val = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        val = potential( obj, s( 2 ).subs{ : } );        
      otherwise
        val = builtin( 'subsref', obj, s );
    end
  case '()'
    %  energy
    enei = cell2mat( s.subs ); 
    val = initmat( obj, enei );
end
