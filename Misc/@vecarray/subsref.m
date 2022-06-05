function varargout = subsref( obj, s )
%  Derived properties for objects of class VECARRAY.
%
%  Usage for obj = vecarray :
%    val = obj( opt )
%  Input
%    opt    :  option array for plotting

switch s( 1 ).type
  case '.'
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );        
  case '()'
    %  extract plot options
    opt = s( 1 ).subs{ : };
    %  get vector
    if ispage( obj )
      varargout{ 1 } = opt.fun( obj.vec( :, :, opt.ind ) );
    else
      varargout{ 1 } = opt.fun( obj.vec );
    end
end
