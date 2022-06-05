function obj = clear( obj )
%  CLEAR - Clear Green functions and auxiliary matrices.
%
%  Usage for obj = bemret :
%    obj = clear( obj )

[ obj.G1i, obj.G2i, obj.L1, obj.L2, obj.Sigma1, obj.Deltai, obj.Sigmai ] = deal( [] );
