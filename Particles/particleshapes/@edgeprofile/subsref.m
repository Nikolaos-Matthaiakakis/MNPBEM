function varargout = subsref( obj, s )
%  Derived properties for objects of class EDGESHIFT.
%
%  Usage for obj = edgeprofile :
%    dmin   :  minimal d-value for edge profile
%    dmax   :  maximal d-value for edge profile
%    zmin   :  minimal z-value for edge profile
%    zmax   :  maximal z-value for edge profile

switch s( 1 ).type
case '.'
  switch s( 1 ).subs
    case 'dmin'
      varargout{ 1 } = min( obj.pos( :, 1 ) );
    case 'dmax'
      varargout{ 1 } = max( obj.pos( :, 1 ) );    
    case 'zmin'
      varargout{ 1 } = min( obj.pos( :, 2 ) );
    case 'zmax'
      varargout{ 1 } = max( obj.pos( :, 2 ) );
    otherwise
      [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );        
  end
end
