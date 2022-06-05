function obj = init( obj, varargin )
%  INIT - Initialize Green function object and layer structure.
%  
%  Usage for obj = greenretlayer :
%    obj = init( obj, op )
%  Input
%    op   :  options (see BEMOPTIONS)

%  options for Green function
op = getbemoptions( { 'green', 'greenlayer', 'greenretlayer' }, varargin{ : } );
%  derivative 'norm' or 'cart'
if isfield( op, 'deriv' ) && ~isempty( op.deriv ),  obj.deriv = op.deriv;  end

%  initialize layer structure
obj.layer =  op.layer;
%  table for Green function interpolation
obj.tab = op.greentab;

%  index to elements with refinement
ir = green.refinematrixlayer( obj.p1, obj.p2, obj.layer, op );
%  index to diagonal boundary elements and elements with refinement
obj.id  = find( ir( : ) == 2 );
obj.ind = find( ir( : ) == 1 );
%  elements with refinement ?
%    if OP contains a field OFFDIAG that is set to 'full' the integration
%    over the boundary elements is performed in INITREFL,
%    this approach is more exact but can be significantly slower
if isempty( obj.ind ) ||  ...
    ( isfield( op, 'offdiag' ) && strcmp( op.offdiag, 'full' ) )
  return
end

switch obj.deriv
  case 'norm'
    obj = init1( obj, ir, op );
  case 'cart'
    obj = init2( obj, ir, op );
end
