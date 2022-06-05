function g = eval1( obj, i, j, key, enei )
%  EVAL1 - Evaluate retarded Green function (full matrix).
%
%  Usage for obj = compgreenret :
%    g = eval1( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%    enei   :  light wavelength in vacuum

%  evaluate connectivity matrix
con = obj.con{ i, j };
%  evaluate dielectric functions to get wavenumbers
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.p1.eps );
 
%  evaluate G, F, H1, H2
if ~strcmp( key, { 'Gp', 'H1p', 'H2p' } )
  %  allocate array
  g = zeros( obj.p1.n, obj.p2.n );
  %  loop over composite particles
  for i1 = 1 : size( con, 1 )
  for i2 = 1 : size( con, 2 )
    if con( i1, i2 )
      %  add Green function
      g( obj.p1.index( i1 ),  ...
         obj.p2.index( i2 ) ) = eval( obj.g{ i1, i2 }, k( con( i1, i2 ) ), key );
    end
  end
  end 
%  evalulate Gp, H1p, H2p
else
  %  allocate array
  g = zeros( obj.p1.n, 3, obj.p2.n );
  %  loop over composite particles
  for i1 = 1 : size( con, 1 )
  for i2 = 1 : size( con, 2 )
    if con( i1, i2 )
      %  add Green function
      g( obj.p1.index( i1 ), :,  ...
         obj.p2.index( i2 ) ) = eval( obj.g{ i1, i2 }, k( con( i1, i2 ) ), key );
    end
  end
  end 
end

if all( g( : ) == 0 );  g = 0;  end
    