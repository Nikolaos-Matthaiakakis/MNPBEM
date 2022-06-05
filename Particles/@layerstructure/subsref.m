function varargout = subsref( obj, s )
%  Access to class functions and properties of layer structure.
%
%  Usage for obj = layerstructure :
%    obj.n                  :  number of layers
%    obj.indlayer( z )      :  index to layers
%    obj.mindist(  z )      :  minimum distance to layer
    
switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case 'indlayer'
        [ varargout{ 1 : nargout } ] = indlayer( obj, s( 2 ).subs{ : } );
      case 'mindist'
        [ varargout{ 1 : nargout } ] = mindist( obj, s( 2 ).subs{ : } ); 
      case 'n'
        varargout{ 1 } = numel( obj.z );
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end  
end
