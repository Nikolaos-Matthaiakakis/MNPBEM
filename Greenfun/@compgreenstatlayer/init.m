function obj = init( obj, varargin )
%  INIT - Initialize Green function object for layer structure.
%  
%  Usage for obj = compgreenstatlayer :
%    obj = init( obj, op )
%    obj = init( obj, op, PropertyPair )      
%  Input
%    op   :  options (see BEMOPTIONS)

%  particles
[ p1, p2 ] = deal( obj.p1, obj.p2 );
%  extract options
op = getbemoptions( { 'greenlayer', 'greenstatlayer' }, varargin{ : } );
%  layer structure
obj.layer = op.layer;
%  make sure that only single layer (substrate) 
assert( obj.layer.n == 1 );

%  index to boundary elements of P2 located in layer
[ ind, obj.indl ] = indlayer( obj.layer, p2.pos( :, 3 ) );
obj.indl = find( obj.indl );
%  make sure that all positions of P2 are located in upper medium
assert( all( ind == obj.layer.ind( 1 ) ) );
%  elements of P2 not located in layer
obj.ind2 = setdiff( 1 : p2.n, obj.indl );
%  elements of P1 located above layer
obj.ind1 =  ...
  find( indlayer( obj.layer, p1.pos( :, 3 ) ) == obj.layer.ind( 1 ) );

%  vector for displacement
vec = [ 0, 0, - obj.layer.z ];
%  reflected particle
obj.p2r = shift( flip( select( shift( p2, vec ), 'index', obj.ind2 ), 3 ), - vec );

%  Green function 
obj.g = compgreenstat( p1, p2, op );

if ~isempty( obj.ind1 )
  obj.gr = compgreenstat( select( p1, 'index', obj.ind1 ), obj.p2r, op, 'waitbar', 0 );
end

