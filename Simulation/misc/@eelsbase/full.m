function a = full( obj, a, ind )
%  FULL - Expand array for electron beams inside of particle to all impact
%         parameters.
%
%  Usage for obj = eelsbase :
%    a = full( obj, a, ind )
%  Input
%    a      :  array for electron beams inside of particle
%    ind    :  index to selected electron beams
%  Output
%    a      :  array for all impact parameters

if ~exist( 'ind', 'var' );  ind = 1 : size( a, 2 );  end

%  size of array
siz = [ size( a, 1 ), size( obj.impact, 1 ) ];

if ~isempty( ind )
  %  indices
  [ i, j ] = ndgrid( 1 : siz( 1 ), 1 : length( ind ) );
  %  accumulate array
  a = accumarray( { i( : ), obj.indimp( ind( j( : ) ) ) },  ...
                                    reshape( a( :, ind ), [], 1 ), siz );
else
  a = zeros( siz );
end
