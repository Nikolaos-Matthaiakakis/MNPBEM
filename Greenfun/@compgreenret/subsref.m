function varargout = subsref( obj, s )
%  Derived properties for objects of class COMPGREENRET.
%
%  Usage for obj = compgreenret :
%    obj{ i, j }.G( enei )  :  composite Green function connecting the
%                              in/outsides (i,j) of particles for a
%                              light wavelength enei in vacuum
%    obj.field( sig )       :  call     field 
%    obj.potential( sig )   :  call potential 
%    obj.deriv              :  'cart' or 'norm'
%
%    works for { G, Gp, F, H1, H2, H1p, H2p } (see greenret)

switch s( 1 ).type
  case '.'    
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } );   
      case 'deriv'
        varargout{ 1 } = obj.g{ 1 }.deriv;        
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
  case '{}'
    %  Green function and or surface derivative of Green function  
    varargout{ 1 } =  ...
      eval( obj, s( 1 ).subs{ : }, s( 2 ).subs, s( 3 ).subs{ : } );
end
