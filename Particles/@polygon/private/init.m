function [ pos, dir, sym ] = init( varargin )
%  INIT - Initialize polygon with n positions.
%
%  Usage :
%    [ pos, dir, sym ] = init(      n, 'PropertyName', PropertyValue, ... )
%    [ pos, dir, sym ] = init( 'n', n, 'PropertyName', PropertyValue, ... )
%      Initialize polygon with n vertices
%    [ pos, dir, sym ] = init( 'pos', pos, 'PropertyName', PropertyValue, ... )
%      Initialize polygon with given positions
%  PropertyName
%    dir    :  direction of polygon (clockwise or counterclockwise)
%    sym    :  symmetry keyword [], 'x', 'y', or 'xy'
%    size   :  scale polygon with [ size( 1 ), size( 2 ) ]
%  Output
%    pos    :  positions of polygon (x,y)
%    dir    :  direction of polygin (1 on default)
%    sym    :  symmetry ([] on default)

if isnumeric( varargin{ 1 } )
  switch length( varargin{ 1 } )
    case 1
      n = varargin{ 1 };
    otherwise
      pos = varargin{ 1 };
  end
  varargin = varargin( 2 : end );
end

for i = 1 : 2 : length( varargin )
  switch varargin{ i }
%%  polygon positions
    case 'n'
      n = varargin{ i + 1 };
    case 'pos'
      pos = varargin{ i + 1 };
%%  direction, symmetry, and size
    case 'dir'
      dir = varargin{ i + 1 };
    case 'sym'
      sym = varargin{ i + 1 };
    case 'size'
      siz = varargin{ i + 1 };
  end
end

%%  position initialization
if exist( 'n', 'var' )
  phi = ( 0 : n - 1 )' / n * 2 * pi + pi / n;
  pos = [ cos( phi ), sin( phi ) ];
end

%%  default values and scaling
if ~exist( 'dir', 'var' );  dir = 1;   end
if ~exist( 'sym', 'var' );  sym = [];  end

if exist( 'siz', 'var' )
  pos( :, 1 ) = siz(   1 ) /  ...
      ( max( pos( :, 1 ) ) - min( pos( :, 1 ) ) ) * pos( :, 1 );
  pos( :, 2 ) = siz( end ) /  ...
      ( max( pos( :, 2 ) ) - min( pos( :, 2 ) ) ) * pos( :, 2 );      
end
  