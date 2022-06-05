function obj = init( obj, varargin )
%  INIT - Initialize comparticle object with mirror symmetry.
%
%    obj = init( obj,         op, PropertyPair )
%    obj = init( obj,             PropertyPair )      
%    obj = init( obj, closed, op, PropertyPair )
%    obj = init( obj, closed,     PropertyPair )
%  Input
%    closed        :  arguments passed to CLOSED
%    op            :  options
%    PropertyPair  :  additional property names and values
%                       OP or PropertyName must contain a field SYM
%                       set to the symmetry keys 'x', 'y', or 'xy'
%                       which determines the chosen mirror symmetry

%  handle input
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ) || ischar( varargin{ i } )
    if ( i == 1 ) 
      close = {};  
    else
      close = varargin( 1 : i - 1 );
      varargin = varargin( i : end );
    end
    break;  
  end
end
%  get options
if isstruct( varargin{ 1 } )
  op = getbemoptions( varargin{ 1 }, {}, varargin{ 2 : end } );
else
  op = getbemoptions( struct, {}, varargin{ : } );
end
%  symmetry
obj.sym = op.sym;

%  table for mirror symmetry
switch obj.sym
  case { 'x', 'y' }
    obj.symtable = [ 1, 1; 1, - 1 ];            %  '+' ; '-'
  case { 'xy' }
    obj.symtable = [ 1,   1,   1,   1;  ...     %  '++'
                     1,   1, - 1, - 1;  ...     %  '+-'
                     1, - 1,   1, - 1;  ...     %  '-+'
                     1, - 1, - 1,   1 ];        %  '--'
end

%  make full particle using mirror symmetry
%    get first mirror symmetry for x and y direction
mirror = { { 'x', 'xy' }, { 'y', 'xy' } };
%  start with particle
[ p, inout ] = deal( obj.p, obj.inout );
%  add equivalent particles by applying mirror symmetry operations
for k = 1 : 2
for i = 1 : length( p )
  if any( strcmp( obj.sym, mirror{ k } ) )
    p{ end + 1 } = flip( p{ i }, k );
    inout = [ inout; inout( i, : ) ];
  end
end
end

%  initialize full particle
obj.pfull = comparticle( obj.eps, p, inout, varargin{ : } );
%  index for closed surfaces
obj = closed( obj, close{ : } );
