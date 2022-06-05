function varargout = subsref( obj, s )
%  Derived properties for objects of class COMPGREENRET.
%
%  Usage for obj = aca.compgreenret :
%    obj{ i, j }.G( enei )  :  composite Green function connecting the
%                              in/outsides (i,j) of particles for a
%                              light wavelength enei in vacuum
%    obj.potential( sig )   :  call potential 
%
%    works for { G, F, H1, H2 }

switch s( 1 ).type
  case '.'    
    switch s( 1 ).subs
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } );   
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
  case '{}'
    %  Green function or surface derivative of Green function  
    varargout{ 1 } =  ...
      eval( obj, s( 1 ).subs{ : }, s( 2 ).subs, s( 3 ).subs{ : } );
end
