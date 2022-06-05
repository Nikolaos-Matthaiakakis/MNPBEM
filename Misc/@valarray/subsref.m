function varargout = subsref( obj, s )
%  Derived properties for objects of class VALARRAY.
%
%  Usage for obj = valarray :
%    val = obj( opt )
%  Input
%    opt    :  option array for plotting with fields FUN and IND

switch s( 1 ).type
  case '.'
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );        
  case '()'
    %  extract plot options
    opt = s( 1 ).subs{ : };
    if obj.truecolor
      varargout{ 1 } = obj.val;
    elseif ~ispage( obj )
      varargout{ 1 } = opt.fun( obj.val );
    else
      varargout{ 1 } = opt.fun( obj.val( :, opt.ind ) );
    end
end
