function c = min( obj, opt )
%  MIN - Minimum of VECARRAY.
%
%  Usage for obj = vecarray :
%    c = min( obj, opt )
%  Input
%    opt    :  plot options
%  Output
%    c      :  minimum of vector array

c = min( vecnorm( subsref( obj, substruct( '()', { opt } ) ) ) );
