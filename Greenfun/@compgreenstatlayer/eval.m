function varargout = eval( obj, enei, varargin )
%  EVAL - Evaluate retarded Green function.
%
%  Usage for obj = compgreenstatlayer :
%    varargout = eval( obj, enei, key )
%  Input
%    enei   :  light wavelength in vacuum
%    key    :  G   -  Green function
%              F   -  Surface derivative of Green function
%              H1  -  F + 2 * pi
%              H2  -  F - 2 * pi
%              Gp  -  derivative of Green function
%  Output
%    varargout  :  requested Green functions

%  dielectric functions of medium in upper and lower layer medium
eps1 = obj.layer.eps{ 1 }( enei );
eps2 = obj.layer.eps{ 2 }( enei );
%  multiplication factor for upper and lower medium, and for elements in layer
f1 = accumarray( obj.ind1, 1, [ obj.p1.n, 1 ], [], 2 * eps1 / ( eps2 + eps1 ) );
fl = 2 * accumarray( obj.ind1, eps1, [ obj.p1.n, 1 ], [], eps2 ) / ( eps1 + eps2 );
%  image charge factor in upper medium
f2 = - ( eps2 - eps1 ) / ( eps2 + eps1 );

%  string comparison function
fun = @( key ) any( strcmp( key, varargin ) );

%  Green function
if fun( 'G' )
  %  direct part
  G = bsxfun( @times, eval( obj.g, 'G' ), f1 );
  %  correct for contributions in layer
  G( :, obj.indl ) = bsxfun( @times, G( :, obj.indl ), fl );
  %  add reflected part
  G( obj.ind1, obj.ind2 ) =  ...
  G( obj.ind1, obj.ind2 ) + f2 * eval( obj.gr, 'G' );
end
%  surface derivative of Green function  
if fun( 'F' ) || fun( 'H1' ) || fun( 'H2' )
  %  direct part
  F = bsxfun( @times, eval( obj.g, 'F' ), f1 );
  %  correct for contributions in layer
  ind = setdiff( obj.ind1, obj.indl );
  F( ind, obj.indl ) = bsxfun( @times, F( ind, obj.indl ), 1 + f2 );
  %  add reflected part
  F( obj.ind1, obj.ind2 ) =  ...
  F( obj.ind1, obj.ind2 ) + f2 * eval( obj.gr, 'F' ); 
%  derivative of Green function
elseif fun( 'Gp' )  
  %  direct part
  Gp = matmul( diag( f1 ), eval( obj.g, 'Gp' ) );  
  %  correct for contributions in layer
  Gp( :, :, obj.indl ) = matmul( diag( fl ), Gp( :, :, obj.indl ) );
  %  add reflected part
  if ~isempty( obj.gr )
    Gp( obj.ind1, :, obj.ind2 ) =  ...
    Gp( obj.ind1, :, obj.ind2 ) + f2 * eval( obj.gr, 'Gp' );
  end
end

if obj.p1 == obj.p2
  %  set F for flat boundary elements in substrate interface equal to zero
  % F( sub2ind( size( F ), obj.indl, obj.indl ) ) = 0;
  F( obj.indl, obj.indl ) = 0;
  %  diagonal part of surface derivative of Green function
  f = accumarray( obj.indl, f2, [ obj.p1.n, 1 ] ); 
  %  singular part of surface derivative of Green function
  if fun( 'H1' ),  H1 = F + 2 * pi * ( diag( f ) + eye( obj.p1.n ) );  end
  if fun( 'H2' ),  H2 = F + 2 * pi * ( diag( f ) - eye( obj.p1.n ) );  end
end
  
%  assign output
varargout = cell( 1, numel( varargin ) );
%  loop over key values
for i = 1 : numel( varargin )
  switch varargin{ i }
    case 'd'
      varargout{ i } = misc.pdist2( obj.p1.pos, obj.p2.pos );
    case 'G'
      varargout{ i } = G;
    case 'F'
      varargout{ i } = F;
    case 'H1'
      varargout{ i } = H1;
    case 'H2'
      varargout{ i } = H2;
    case 'Gp'
      varargout{ i } = Gp;
  end
end

  