function varargout = subsref( obj, s )
%  Class properties and derived properties for eelsbase objects.
%
%  Usage for obj = eelsbase :
%    obj.path       :  path length for electron beams propagating in media
%    obj.potinfty   :  potential for extended electron beam
%    obj.potinside  :  potential for charged wire

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case 'path'
        varargout{ 1 } = path( obj, s( 2 ).subs{ : } );        
      case 'potinfty'
        [ varargout{ 1 : nargout } ] = potinfty(  obj, s( 2 ).subs{ : } );        
      case 'potinside'
        [ varargout{ 1 : nargout } ] = potinside( obj, s( 2 ).subs{ : } );        
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end
end
