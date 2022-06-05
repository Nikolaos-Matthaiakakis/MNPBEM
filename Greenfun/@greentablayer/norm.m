function [ G, Fr, Fz ] = norm( obj )
%  NORM - Multiply Green function with distance-dependent factors.
%
%  Usage for obj = greentablayer :
%    [ G, Fr, Fz ] = norm( obj )
%  Output
%    G       :  Green function
%    Fr, Fz  :  surface derivatives of Green function

%  make sure that Green function has been evaluated
assert( ~isempty( obj.G ) );

%  tabulated radii and minimal distances
[ r, zmin ] = deal( obj.pos.r, obj.pos.zmin );
%  distance 
d = sqrt( r .^ 2 + zmin .^ 2 );

%  get field names
names = fieldnames( obj.G );
%  loop over field names
for i = 1 : length( names )
  %  Green function
  G.( names{ i } ) = obj.G.( names{ i } ) .* d;
  %  radial and z derivatives of Green function
  Fr.( names{ i } ) = obj.Fr.( names{ i } ) .* d .^ 3 ./ r; 
  Fz.( names{ i } ) = obj.Fz.( names{ i } ) .* d .^ 3 ./ zmin; 
end
