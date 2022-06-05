function con = connect( varargin )
%  CONNECT - connectivity between compound points or particles.
%
%  Usage
%    con = connect( p1     )
%    con = connect( p1, p2 )
%    con = connect( p1,     ind )
%    con = connect( p1, p2, ind )
%  Input
%    p1     :  compound object 1
%    p2     :  compound object 2
%    ind    :  replace dielectric materials according to ind
%  Output
%    con    :  cell array of logical arrays indicating whether 
%                compound points (particles) can see each other

%  get masked inout property
get = @( p ) ( p.inout( p.mask, : ) );

%%  extract input
switch nargin
  case 1
    %  single particle
    inout = { get( varargin{ 1 } ) };
  case 2
    if isnumeric( varargin{ 2 } )
      %  single particle and index for replacement
      ind = varargin{ 2 };  
      inout = { ind( get( varargin{ 1 } ) ) };  
    else
      %  two particles
      inout = { get( varargin{ 1 } ), get( varargin{ 2 }) };
    end
  case 3
    %  two particles and index for replacement
    ind = varargin{ 3 };
    inout = { ind( get( varargin{ 1 } ) ), ind( get( varargin{ 2 } ) ) };
end

%%  compute connectivity matrix
%  size of INOUT 
n1 = size( inout{   1 }, 2 );
n2 = size( inout{ end }, 2 );
%  allocate array
con = cell( n1, n2 );

%  determine whether points can see each other
for i = 1 : size( inout{   1 }, 2 )
for j = 1 : size( inout{ end }, 2 )
  io1 = inout{   1 }( :, i );
  io2 = inout{ end }( :, j );
  c1 = repmat( io1,  [ 1, length( io2 ) ] );
  c2 = repmat( io2', [ length( io1 ), 1 ] );
  con{ i, j } = zeros( size( c1 ) );
  con{ i, j }( c1 == c2 ) = c1( c1 == c2 );
end
end
