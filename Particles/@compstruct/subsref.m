function varargout = subsref( obj, s )
%  Access to properties of compstruct objects.
%    
%  Usage for obj = compstruct :
%    obj.p          :  points or particle surfaces
%    obj.enei       :  light wavelength in vacuum
%    obj.name       :  get value of other field names

switch s( 1 ).type  
  case '.'
    switch s( 1 ).subs;
      %  class variables   
      case 'enei'
        varargout{ 1 } = builtin( 'subsref', obj, s ); 
      case 'p'
        [ varargout{ 1 : nargout } ] = subarray( obj.p, s );
      %  additional fields
      otherwise
        varargout{ 1 } = builtin( 'subsref', obj.val, s );
    end
end

  