function varargout = eval( obj, varargin )
%  EVAL - Evaluate Green function.
%
%  Usage for obj = aca.compgreenstat :
%    varargout = eval( obj, key1, key2, ... )
%  Input
%    ind    :  index to matrix elements to be computed
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%  Output
%    varargout  :  requested Green functions

%  particle 
p = obj.p;
%  options for ACA
hmat = obj.hmat;
op = struct( 'htol', min( hmat.htol ), 'kmax', max( hmat.kmax ) );
%  assign output
varargout = cell( 1, nargout );

for i = 1 : numel( varargout )
  %  check for input
  if strcmp( varargin{ i }, 'Gp' )
    error( 'Gp not implemented for aca.compgreenstat' );  
  end
  
  %  fill full matrices
  fun = @( row, col ) eval( obj.g, sub2ind( [ p.n, p.n ], row, col ), varargin{ i } );
  %  compute full matrices
  hmat = fillval( hmat, fun );  
  
  %  particle structure for MEX function call
  ind = hmat.tree.ind( :, 1 );
  pmex = struct( 'pos', p.pos( ind, : ), 'nvec', p.nvec( ind, : ), 'area', p.area( ind ) );
  %  tree and cluster indices for MEX function call
  tmex = treemex( hmat );
  %  compute low-rank approximation
  switch varargin{ i }
    case 'G'
      [ hmat.lhs, hmat.rhs ] = hmatgreenstat( pmex, tmex, 'G', op );
    case { 'F', 'H1', 'H2' }
      [ hmat.lhs, hmat.rhs ] = hmatgreenstat( pmex, tmex, 'F', op );
  end
 
  %  assign output
  varargout{ i } = hmat;
end
