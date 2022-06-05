function tree = treemex( obj )
%  TREEMEX - Tree structure to be passed to MEX functions of HLIB.
%
%  Usage for obj = hmatrix :
%    tree = treemex( obj )
%  Output
%    tree     :  structure to be passed to MEX functions of HLIB
%                  sons   -  sons for each cluster
%                  ind    -  cluster indices
%                  ind1   -  indices for full matrices
%                  ind2   -  indices for low-rank matrices
%                  ipart  -  particle index

%  cluster tree
tree = obj.tree;

%    C++ arrays start with 0, Matlab arrays start with 1
sons = uintmex( tree.son  - 1 );
ind  = uintmex( tree.cind - 1 );
%  indices to full and low-rank matrices
ind1 = uintmex( [ obj.row1, obj.col1 ] - 1 );
ind2 = uintmex( [ obj.row2, obj.col2 ] - 1 );
%  particle index (0 for composite particles)
ipart = uintmex( tree.ipart );

%  structure to be passed to MEX functions of HLIB
tree = struct( 'sons', sons, 'ind', ind,  ...
               'ind1', ind1, 'ind2', ind2, 'ipart', ipart );
