function varargout = subsref( obj, s )
%  Derived properties for objects of class greenret.
%
%  Usage for obj = greenret :
%    obj.G    :  Green function
%    obj.F    :  surface derivative of Green function
%    obj.H1   :  F + 2 pi
%    obj.H2   :  F - 2 pi
%    obj.Gp   :  derivative of Green function

switch s( 1 ).type
  case '.'    
    switch s( 1 ).subs        
      %  Green function/surface derivative of Green function  
      case { 'G', 'F', 'H1', 'H2', 'Gp' }
        %  
        varargout{ 1 } = eval( obj, s( 2 ).subs{ : }, s( 1 ).subs );
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end
end
