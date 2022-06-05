function obj = setstat( obj, name, hmat )
%  SETSTAT - Set statistics for H-matrices.
%
%  Usage for obj = bemiter :
%    obj = setstat( obj, name, hmat )
%  Input
%     name    :  name of H-matrix
%     hmat    :  corresponding H-matrix

stat = obj.stat;

if isempty( stat )
  stat = struct( 'compression', struct );
elseif ~isempty( obj.eneisav ) &&  ...
  ~( issorted( [ obj.eneisav; obj.enei ] ) || issorted( flipud( [ obj.eneisav; obj.enei ] ) ) )
  %  reset statistics
  stat = struct( 'compression', stuct );
end

%  compression for H-matrix
if ~isfield( stat.compression, name )
  stat.compression.( name ) = compression( hmat );
else
  stat.compression.( name ) = [ stat.compression.( name ), compression( hmat ) ];
end
%  timing
if ~isempty( hmat.stat )
  %  loop over field names
  for name = reshape( fieldnames( hmat.stat ), 1, [] )
    if ~isfield( stat, name{ 1 } )
      stat.( name{ 1 } ) = hmat.stat.( name{ 1 } );
    else
      stat.( name{ 1 } ) = [ stat.( name{ 1 } ), hmat.stat.( name{ 1 } ) ];
    end
  end
end


%  save statistics
obj.stat = stat;
