function obj = flip( obj, varargin )
%  FLIP - Flip discretized particle surface along given direction.
%
%  Usage for obj = particle :
%    obj = flip( obj, dir )
%    obj = flip( obj, dir, varargin )
%  Input
%    dir        :  direction along which particle is flipped (default dir = 1)
%    varargin   :  additional arguments to be passed to NORM
%  Output
%    obj    :  flipped particle

if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ dir, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  dir = 1;
end

%  flip vertices
obj.verts( :, dir ) = - obj.verts( :, dir );
if ~isempty( obj.verts2 ),  obj.verts2( :, dir ) = - obj.verts2( :, dir );  end

%  flip faces
obj = flipfaces( obj, varargin{ : } );
