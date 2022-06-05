function hinfo( obj )
%  HINFO - Print information about H-matrices.
%
%  Usage for obj = bemiter :
%    hinfo( obj )

stat = obj.stat;
%  empty statistics
if ~isfield( stat, 'compression' ),  return;  end

%  compression factors
[ eta1, eta2 ] = deal( [] );
%  loop over fieldnames
for name = reshape( fieldnames( stat.compression ), 1, [] )
  switch name{ 1 }
    case { 'G', 'F', 'G1', 'H1', 'G2', 'H2' }
      eta1 = [ eta1, stat.compression.( name{ 1 } ) ];
    otherwise
      eta2 = [ eta2, stat.compression.( name{ 1 } ) ];
  end
end

fprintf( 1, '\nCompression Green functions        :  %8.6f\n',   mean( eta1 ) );
fprintf( 1,   'Compression auxiliary matrices     :  %8.6f\n\n', mean( eta2 ) );

%  timing
if ~isfield( stat, 'main' ),  return;  end
%  total time
tall = sum( stat.main );
tsum = 0;

%  print total time
fprintf( 1,   'Total time for H-matrix operations :  %-9.3f sec\n', tall );

for name = reshape( fieldnames( stat ), 1, [] )
  if ~any( strcmp( name{ 1 }, { 'main', 'compression' } ) )
    %  print percentage of time
    fprintf( 1, '  %-12s : %6.2f %%\n', name{ 1 }, 100 * sum( stat.( name{ 1 } ) ) / tall );
    %  add time
    tsum = tsum + sum( stat.( name{ 1 } ) );
  end
end

%  print rest percentage
fprintf( 1, '  %-12s : %6.2f %%\n', 'rest', 100 * ( 1 - tsum / tall ) );
