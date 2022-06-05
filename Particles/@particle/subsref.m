function val = subsref( obj, s )
%  Derived properties for objects of class particle.
%
%  Usage for obj = particle :
%    obj.nvec           :  normal vectors of surface elements
%    obj.tvec           :  tangential vectors of surface elements
%    obj.tvec1          :  1st tangential vector
%    obj.tvec2          :  2nd tangential vector
%    obj.nfaces         :  number of surface elements
%    obj.nverts         :  number of vertices

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

    case { 'nfaces', 'size', 'n' }
      val = size( obj.faces, 1 );
    case 'nverts'
      val = size( obj.verts, 1 );   
    otherwise
      val = builtin( 'subsref', obj, s );        
  end
end
