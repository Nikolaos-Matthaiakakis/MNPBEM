function varargout = subsref( obj, s )
%  Class properties and derived properties for EELSSTAT objects.
%
%  Usage for obj = eelsstat :
%    obj( enei )        :  external potential for use in bemstat
%    obj.loss( sig )    :  EELS loss probability

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case 'loss'
        [ varargout{ 1 : nargout } ] = loss( obj, s( 2 ).subs{ : } );        
      otherwise
        [ varargout{ 1 : nargout } ] = subsref@eelsbase( obj, s );
    end
  case '()'
    [ varargout{ 1 : nargout } ] = potential( obj, s( 1 ).subs{ : } );
end
