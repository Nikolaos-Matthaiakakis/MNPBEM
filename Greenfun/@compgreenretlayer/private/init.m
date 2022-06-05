function obj = init( obj, varargin )
%  INIT - Initialize Green function object and layer structure.
%  
%  Usage for obj = compgreenretlayer :
%    obj = init( obj, op )
%  Input
%    op   :  options (see BEMOPTIONS)

%  options for Green function
op = getbemoptions( { 'greenlayer', 'greenretlayer' }, varargin{ : } );

%  initialize Green function and layer structure
[ obj.g, obj.layer ] =  ...
  deal( compgreenret( obj.p1, obj.p2, varargin{ : } ), op.layer );

%  inout argument 
inout1 = obj.p1.expand( num2cell( obj.p1.inout( :, end ) ) );
inout2 = obj.p2.expand( num2cell( obj.p2.inout( :, end ) ) );
%  find elements connected to layer structure
obj.ind1 = find( any( bsxfun( @eq, inout1, obj.layer.ind ), 2 ) );
obj.ind2 = find( any( bsxfun( @eq, inout2, obj.layer.ind ), 2 ) );

%  compoint and comparticle objects with boundary elements connected to
%  layer structure
p1 = obj.p1.p;  p1 = select( vertcat( p1{ : } ), 'index', obj.ind1 );
p2 = obj.p2.p;  p2 = select( vertcat( p2{ : } ), 'index', obj.ind2 );
%  initialize reflected part of Green function
obj.gr = greenretlayer( p1, p2, varargin{ : } );
