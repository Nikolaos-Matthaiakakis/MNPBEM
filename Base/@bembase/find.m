function class = find( name, op, varargin )
%  FIND - Select classname from subclasses of BEMBASE using option structure.
%
%  Usage :
%    class = find( name, op )
%    class = find( name, op, PropertyName, PropertyValue )
%  Input
%    name           :  task name
%    op             :  option structure
%    PropertyName   :  additional fields added to OP
%  Output
%    class          :  class name among subclasses of BEMBASE where all
%                      needs are fulfilled

%  get list of all BEMBASE subclasses
list = misc.subclasses( 'bembase' );
%  number of NEEDS agreements with options
n = zeros( size( list ) );
%  add property pairs to option structure
for i = 1 : 2 : length( varargin )
  op.( varargin{ i } ) = varargin{ i + 1 };
end

%  loop through list
for i = 1 : length( list )
  %  classes with name matching NAME
  if strcmp( eval( [ list{ i }, '.name' ] ), name )
    %  get needs of class
    needs = eval( [ list{ i }, '.needs' ] );
    %  loop over NEEDS 
    for j = 1 : length( needs )
      if ischar( needs{ j } )
        needs{ j } = isfield( op,  needs{ j } ) &&  ...
                    ~isempty( op.( needs{ j } ) );
      else
        %  get fieldname of structure
        fname = subsref( fieldnames( needs{ j } ), substruct( '{}', {} ) );
        %  compare with OP entries
        needs{ j } = isfield( op, fname ) &&   ...
                     isequal( op.( fname ), needs{ j }.( fname ) );
      end 
    end
    %  number of agreements
    if all( cell2mat( needs ) ),   n( i ) = numel( needs );  end
  end
end

%  find maximum number of agreements
[ ~, i ] = max( n );  
% return name of class or empty cell if not all options match
if n( i ) == 0,  class = {};  else  class = list{ i };  end
