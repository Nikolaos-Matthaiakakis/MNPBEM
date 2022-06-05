function op = getbemoptions( varargin )
%  GETBEMOPTIONS - Get options for MNPBEM simulation.
%
%  Usage :
%    op = getbemoptions( op, PropertyPairs, { sub1, sub2, ... } )
%  Input
%    op     :  structure with options
%    PropertyPairs 
%            :  additional properties (with name and value) that override
%               the properties of OP
%    sub1    :  if OP contains a field with a substructure SUB, the fields 
%               of SUB override those of OP
%  Output
%    op      :  structure with options; in the calling program, the
%               relevant properties can be accessed with OP.FIELDNAME
%
%  Example :
%   op = struct( 'sim', 'ret', 'RelCutoff', 0.1 );
%   op.green = struct( 'RelCutoff', 0.2, 'AbsCutoff', 1.0 );
%   getbemoptions( op, { 'green' }, 'RelCutoff', 0.4 )
% 
%           sim: 'ret'
%     RelCutoff: 0.4000
%         green: [1x1 struct]
%     AbsCutoff: 1

%  input structure and pointer to varargin
[ op, it ] = deal( struct, 1 );
%  work through input
while it <= numel( varargin )
  %  options structure
  if isstruct( varargin{ it } )
    %  get fieldnames
    names = fieldnames( varargin{ it } );
    %  copy elements into op
    for i = 1 : length( names )
      op.( names{ i } ) = varargin{ it }.( names{ i } );
    end
    %  extract fields from substructures
    if exist( 'sub', 'var' ),  op = subs( op, sub );  end
    %  update pointer
    it = it + 1;
  %  property pair
  elseif ischar( varargin{ it } )
    op.( varargin{ it } ) = varargin{ it + 1 };
    %  update pointer
    it = it + 2;
  elseif iscell( varargin{ it } )
    %  get substructure names
    sub = varargin{ it };
    %  extract fields from substructures
    op = subs( op, sub );
    %  update pointer
    it = it + 1;
  else
    error( 'neither option structure nor property pair' );
  end
end


function op = subs( op, sub )
%  SUBS - Extract fields from substructures.

%  get field names
names = fieldnames( op );
%  loop over substructures
for i = 1 : length( sub )
  if any( strcmp( sub{ i }, names ) )
    %  fieldnames of SUB
    s = fieldnames( op.( sub{ i } ) );
    %  copy fieldnames of SUB to OP
    for j = 1 : length( s )
      op.( s{ j } ) = op.( sub{ i } ).( s{ j } );
    end
  end
end
