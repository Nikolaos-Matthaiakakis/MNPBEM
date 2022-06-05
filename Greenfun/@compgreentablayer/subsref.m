function varargout = subsref( obj, s )
%  Derived properties for objects of class COMPGREENTABLAYER.
%
%  Usage for obj = compgreenstat :
%    obj.ismember( layer, varargin )

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case 'ismember'
        varargout{ 1 } = ismember( obj, s( 2 ).subs{ : } );
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
end
