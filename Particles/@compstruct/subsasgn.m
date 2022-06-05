function obj = subsasgn( obj, s, val )
%  Subscripted assignement of compstruct.
%    
%  Usage for obj = compstruct :
%    obj.p    = p       :  set points or particles
%    obj.enei = enei    :  set light wavelength in vacuum
%    obj.name = val     :  set other fields

switch s( 1 ).type    
  case '.'
    switch s( 1 ).subs;
      %  class variables   
      case { 'p', 'enei' }
        obj = builtin( 'subsasgn', obj, s, val ); 
      %  additional fields
      otherwise
        obj.val = builtin( 'subsasgn', obj.val, s, val );
    end
end

  