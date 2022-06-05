function hmat = eval1( obj, i, j, key, enei )
%  EVAL1 - Evaluate retarded Green function for layer structure (direct).
%
%  Deals with calls to obj = aca.compgreenretlayer :
%    g = obj{ i, j }.G( enei )
%
%  Usage for obj = aca.compgreenretlayer :
%    g = eval1( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%    enei   :  light wavelength in vacuum

[ p, hmat ] = deal( obj.p, obj.hmat );
%  fill full matrices
fun = @( row, col ) eval( obj.g, i, j, key, enei, sub2ind( [ p.n, p.n ], row, col ) );
%  compute full matrices
hmat = fillval( hmat, fun );
%  compute low-rank matrices
[ hmat.lhs, hmat.rhs ] = lowrank1( obj, i, j, key, enei );
