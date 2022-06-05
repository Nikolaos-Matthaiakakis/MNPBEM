function varargout = subsref( obj, s )
%  Properties and derived properties for objects of class quadface.
%
%  Usage for obj = quadface :
%    [ pos, w ] = obj( verts ) 
%    [ pos, w ] = obj( v1, v2, v3 )
%    [ pos, w ] = obj( v1, v2, v3, v4 )
%    [ pos, w ] = obj( p, ind )
%  Input
%    verts      :  vertices of boundary element (triangle or quadrilateral)
%    vi         :  vertices of boundary element (triangle or quadrilateral)
%    p          :  particle or comparticle object
%    ind        :  index to face element

switch s( 1 ).type
  case '.'    
    varargout{ 1 } = builtin( 'subsref', obj, s );
  case '()'
    [ varargout{ 1 : nargout } ] = adapt( obj, s( 1 ).subs{ : } );
end

