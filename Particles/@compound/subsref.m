function varargout = subsref( obj, s )
%  Access to point or particle properties of compound objects.
%
%  Usage for obj = compound :
%    val = obj.PropertyName
%  PropertyName
%    eps            :  cell array of dielectric functions
%    p              :  cell array of points or particles
%    inout          :  index to in- and outside medium eps
%    mask           :  mask a given set of particles
%    size           :  number of positions for points or faces
%    n              :  total number of points or faces
%    np             :  number of point sets or particles
%    eps1( enei )   :  inside  dielectric functions
%    eps2( enei )   :  outside dielectric functions
%    index( i )     :  index to positions of given point set or particle
%    ipart( ind )   :  particle number for given position index

switch s( 1 ).type
case '.'
  switch s( 1 ).subs
    %  properties of compound object
    case { 'eps', 'mask' }
      [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s ); 
    case 'p'
      varargout{ 1 } = subarray( obj.p( obj.mask ), s );
    case 'inout'
      varargout{ 1 } = subarray( obj.inout( obj.mask, : ), s );
    case 'size'
      varargout{ 1 } = cellfun( @( p ) ( p.size ), obj.p( obj.mask ) );
    case 'n'
      varargout{ 1 } = sum( cellfun( @( p ) ( p.size ), obj.p( obj.mask ) ) );
    case 'np'
      varargout{ 1 } = length( obj.p( obj.mask ) );
    case 'eps1'
      varargout{ 1 } = expand( obj, dielectric( obj, s( 2 ).subs{ 1 }, 1 ) );
    case 'eps2'
      varargout{ 1 } = expand( obj, dielectric( obj, s( 2 ).subs{ 1 }, 2 ) );
    case 'expand'
      varargout{ 1 } = expand( obj, s( 2 ).subs{ 1 } );
    case 'index'
      varargout{ 1 } = index( obj, s( 2 ).subs{ 1 } );
    case 'ipart'
      varargout{ 1 } = ipart( obj, s( 2 ).subs{ 1 } );
    %  default values
    otherwise
      [ varargout{ 1 : nargout } ] = subsref( obj.pc, s );     
  end
end
