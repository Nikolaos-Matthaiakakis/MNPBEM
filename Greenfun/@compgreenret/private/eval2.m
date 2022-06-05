function g = eval2( obj, i, j, key, enei, ind )
%  EVAL2 - Evaluate retarded Green function (selected matrix elements).
%
%  Usage for obj = compgreenret :
%    g = eval2( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%    enei   :  light wavelength in vacuum
%    ind    :  index to selected matrix elements

%  evaluate connectivity matrix
con = obj.con{ i, j };
%  convert total index to cell array of subindices
[ sub, ind ] = ind2sub( obj.block, ind );

%  evaluate dielectric functions to get wavenumbers
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.p1.eps, 'uniform', 1 );
%  place wavevectors into cell array
con( con == 0 ) = nan;  con( ~isnan( con ) ) = k( con( ~isnan( con ) ) );

%  evaluate Green function submatrices
g = cellfun( @( g, k, sub ) fun( g, k, sub, key ),  ...
                                obj.g, sub, num2cell( con ), 'uniform', 0 );
%  assemply together submatrices                              
g = accumarray( obj.block, ind, g );


function y = fun( g, ind, k, key )
%  FUN - Evaluate Green function submatrices.

if isnan( k )
  switch key
    case { 'G', 'F', 'H1', 'H2' }
      y = zeros( numel( ind ), 1 );
    otherwise
      y = zeros( numel( ind ), 3 );
  end
else
  y = eval( g, ind, k, key );
end
