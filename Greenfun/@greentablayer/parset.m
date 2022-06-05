function obj = parset( obj, enei, varargin )
%  PARSET - Same as SET but with parallel loop.
%
%  Usage for obj = greentablayer :
%    obj = parset( obj, enei )
%  Input
%    enei   :  wavelengths of light in vacuum
%  Output
%    obj    :  precomputed Green function table

%  save wavelength table
obj.enei = enei;

%  compute Green functions
parfor ien = 1 : numel( enei )
  g{ ien } = eval( obj, enei( ien ), 'new' );
end

%  get field names
names = fieldnames( g{ 1 }.G );
%  save position array
obj.pos = g{ 1 }.pos;
%  size of Green function matrix
siz = [ numel( enei ), size( g{ 1 }.G.( names{ 1 } ) ) ];

for i = 1 : length( names )
  %  initialize Green functions
  Gsav.(  names{ i } ) = zeros( siz );  
  Frsav.( names{ i } ) = zeros( siz );
  Fzsav.( names{ i } ) = zeros( siz );
  %  loop over energies
  for ien = 1 : numel( enei )
    %  store Green functions 
    Gsav.(  names{ i } )( ien, : ) = reshape( g{ ien }.G.(  names{ i } ), 1, [] );
    Frsav.( names{ i } )( ien, : ) = reshape( g{ ien }.Fr.( names{ i } ), 1, [] );
    Fzsav.( names{ i } )( ien, : ) = reshape( g{ ien }.Fz.( names{ i } ), 1, [] );
  end
end

%  reshape arrays
for i = 1 : length( names )
  obj.Gsav.(  names{ i } ) = reshape( Gsav.(  names{ i } ), siz );
  obj.Frsav.( names{ i } ) = reshape( Frsav.( names{ i } ), siz );
  obj.Fzsav.( names{ i } ) = reshape( Fzsav.( names{ i } ), siz );
end