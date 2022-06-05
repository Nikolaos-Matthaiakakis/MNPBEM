function val = subsref( obj, s )
%  Derived properties for objects of class point.
%    nvec and tvec are defined for compatibility reasons.
%
%  Usage for obj = points :
%    obj.nvec          :    z-component of vec
%    obj.tvec          :  x,y-component of vec
%    obj.tvec1         :    x-component of vec
%    obj.tvec2         :    y-component of vec

switch s( 1 ).type
case '.'
  switch s( 1 ).subs
    case 'nvec'
      val = subarray( obj.vec{ 3 }, s );
    case 'tvec'
      val = subarray( obj.vec( 1 : 2 ), s );      
    case 'tvec1'
      val = subarray( obj.vec{ 1 }, s );      
    case 'tvec2'
      val = subarray( obj.vec{ 2 }, s );            
    case { 'size', 'n' }
      val = size( obj.pos, 1 );
    otherwise
      val = builtin( 'subsref', obj, s );  
      
  end
end
