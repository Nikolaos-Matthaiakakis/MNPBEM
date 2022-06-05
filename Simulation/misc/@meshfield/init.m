function obj = init( obj, p, x, y, z, varargin )
%  Initialize compound Green function object for layer structure.
%  
%  Usage for obj = meshfield :
%    obj = init( obj, p, x, y, z,               varargin )
%    obj = init( obj, p, x, y, z, 'nmax', nmax, varargin )
%  Input
%    p        :  particle
%    x        :  x-positions for electric field
%    y        :  y-positions for electric field
%    z        :  z-positions for electric field
%    nmax     :  work off calculation in portions of NMAX
%    varargin :  additional arguments to be passed to COMPOINT or
%                to initialization of Green function

%  reshape arrays if needed
if size( unique( [ size( x ); size( y ); size( z ) ], 'rows' ), 1 ) ~= 1
  if     all( size( x ) == size( y ) )
    [ x, y, z ] = expand( x, y, z );
  elseif all( size( x ) == size( z ) )
    [ x, z, y ] = expand( x, z, y ); 
  elseif all( size( y ) == size( z ) )
    [ y, z, x ] = expand( y, z, x );  
  end
end

%  save positions and particle
[ obj.x, obj.y, obj.z, obj.p ] = deal( x, y, z, p );
%  make compoint object
obj.pt = compoint( p, [ x( : ), y( : ), z( : ) ], varargin{ : } );

%  get options
obj.op = getbemoptions( varargin{ : } );
%  work off calculation in portions of NMAX
if isfield( obj.op, 'nmax' )
  obj.nmax = obj.op.nmax;
else
  %  initialize Green function
  obj.g = greenfunction( obj.pt, p, varargin{ : } );
end


function [ x, y, z ] = expand( x, y, z )
%  EXPAND - Expand dimensions.

if numel( z ) == 1
  z = 0 * x + z;
else
  %  size of X and Z
  [ siz1, n2 ] = deal( size( x ), numel( z ) );
  %  make 3d arrays
  x = repmat( reshape( x, [ siz1, 1  ] ), [ 1, 1, n2 ] );
  y = repmat( reshape( y, [ siz1, 1  ] ), [ 1, 1, n2 ] );
  z = repmat( reshape( z, [ 1, 1, n2 ] ), [ siz1, 1  ] );
end
