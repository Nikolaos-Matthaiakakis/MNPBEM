function obj = clear( obj )
%  CLEAR - Clear Green functions and auxiliary matrices.
%
%  Usage for obj = bemretlayeriter :
%    obj = clear( obj )

[ obj.G1, obj.H1, obj.G2, obj.H2, obj.sav ] = deal( [] );
