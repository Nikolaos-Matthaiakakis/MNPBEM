function hmat = eval( obj, i, j, key, enei )
%  EVAL - Evaluate retarded Green function for layer structure.
%
%  Deals with calls to obj = aca.compgreenretlayer :
%    g = obj{ i, j }.G( enei )
%
%  Usage for obj = aca.compgreenretlayer :
%    g = eval( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%    enei   :  light wavelength in vacuum

%  depending on I and J the Green function interaction can be only direct
%  or additionally influenced by layer reflections
if ~( i == 2 && j == 2 )
  hmat = eval1( obj, i, j, key, enei );
else
  hmat = eval2( obj, i, j, key, enei );
end
