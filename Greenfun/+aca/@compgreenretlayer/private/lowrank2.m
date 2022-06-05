function [ lhs, rhs ] = lowrank2( obj, key, name, enei )
%  LOWRANK2 - Evaluate low-rank matrices for layer structure (reflected).
%
%  Usage for obj = aca.compgreenretlayer :
%    [ lhs, rhs ] = lowrank2( obj, key, name, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%    name   :  'p', 'ss', 'sh', 'hs', or 'hh'
%    enei   :  wavelength of light in vacuum
%  Output
%    lhs    :   left-hand side of low-rank matrix
%    rhs    :  right-hand side of low-rank matrix

[ p, hmat ] = deal( obj.p, obj.hmat );
%  size of clusters
tree = hmat.tree;
siz = tree.cind( :, 2 ) - tree.cind( :, 1 ) + 1;
%  allocate low-rank matrices
lhs = arrayfun( @( x ) zeros( x, 1 ), siz( hmat.row2 ), 'uniform', 0 );
rhs = arrayfun( @( x ) zeros( x, 1 ), siz( hmat.col2 ), 'uniform', 0 );

%  COMPGREENTABLAYER object
%    table of reflected Green function, use INSIDE to select cell index
gtab = eval( obj.g.gr.tab, enei );
%   multiply Green function with distance-dependent factors
[ g, fr, fz ] = cellfun( @( gtab ) norm( gtab ), gtab.g, 'uniform', 1 );
%  minimum distance to layer structure
z = mindist( obj.layer, round( obj.layer, p.pos( :, 3 ) ) );

%  particle structure for MEX function call
ind = hmat.tree.ind( :, 1 );
pmex = struct( 'pos', p.pos( ind, : ), 'nvec', p.nvec( ind, : ),  ...
                                       'area', p.area( ind ), 'z', z( ind ) );
%  tree indices and options for MEX function call
tmex = treemex( hmat );
op = struct( 'htol', hmat.htol, 'kmax', hmat.kmax );

for i1 = 1 : p.np
for i2 = 1 : p.np
  %  z-values of first boundary elements
  z1 = p.p{ i1 }.pos( 1, 3 );
  z2 = p.p{ i2 }.pos( 1, 3 );
  %  index to layers within which particles are embedded
  ind1 = uintmex( indlayer( obj.layer, z1 ) );
  ind2 = uintmex( indlayer( obj.layer, z2 ) );
  
  %  starting cluster
  row = uintmex( obj.ind( i1 ) - 1 );
  col = uintmex( obj.ind( i2 ) - 1 );
  %  reshape function
  fun = @( x ) x( : );
  
  %  compute low-rank matrix using ACA
  switch key
    case 'G'
      %  tabulated Green functions
      tab = gtab.g{ inside( gtab, 0, z1, z2 ) };
      tab = struct( 'r', tab.r, 'rmod', obj.rmod,  ...
        'z1', tab.z1, 'z2', tab.z2, 'zmod', obj.zmod, 'G', fun( g.( name ) ) );
      %  compute Green function
      [ L, R ] = hmatgreentab1( pmex, tmex, row, col, tab, ind1, ind2, op );  
    case { 'F', 'H1', 'H2' }
      %  tabulated surface derivatives of Green functions
      tab = gtab.g{ inside( gtab, 0, z1, z2 ) };
      tab = struct( 'r', tab.r, 'rmod', obj.rmod,  ...
        'z1', tab.z1, 'z2', tab.z2, 'zmod', obj.zmod, 'Fr', fun( fr.( name ) ),  ...
                                                      'Fz', fun( fz.( name ) ) );
      %  compute surface derivative of Green function
      [ L, R ] = hmatgreentab2( pmex, tmex, row, col, tab, ind1, ind2, op );
  end        
  
  %  index to low-rank matrices
  ind = cellfun( @( x ) ~isempty( x ), L, 'uniform', 1 );
  %  set low-rank matrices
  lhs( ind ) = L( ind );
  rhs( ind ) = R( ind );
end
end
