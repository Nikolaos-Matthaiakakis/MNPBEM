function obj = rot( obj, angle, varargin )
%  ROT - Rotate discretized particle surface.
%
%  Usage for obj = particle :
%    obj = rot( obj, angle, dir )
%    obj = rot( obj, angle, dir, varargin )
%  Input
%    obj        :  discretized particle surface
%    angle      :  rotation angle (degrees)
%    dir        :  rotation axis (z-axis on default)
%    varargin   :  additional arguments to be passed to NORM
%  Output
%    obj        :  rotated particle surface

if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ dir, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end
%  default value for direction
if ~exist( 'dir', 'var' ) || isempty( dir ),  dir = [ 0, 0, 1 ];  end

%  transform angle to degrees
angle = angle / 180 * pi;
%  make dir to unit vector
dir = dir / norm( dir );

j1 = [ 0,   0, 0;  0, 0, - 1;   0, 1, 0 ];
j2 = [ 0,   0, 1;  0, 0,   0; - 1, 0, 0 ];
j3 = [ 0, - 1, 0;  1, 0,   0;   0, 0, 0 ];
%  rotation matrix
r = expm( - angle * ( dir( 1 ) * j1 + dir( 2 ) * j2 + dir( 3 ) * j3 ) );

%  rotate vertices
obj.verts = obj.verts * r;
if ~isempty( obj.verts2 ),  obj.verts2 = obj.verts2 * r;  end
%  auxiliary information
obj = norm( obj, varargin{ : } );
