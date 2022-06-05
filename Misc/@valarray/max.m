function c = max( obj, opt )
%  MAX - Maximum of VALARRAY.
%
%  Usage for obj = valarray :
%    c = max( obj, opt )
%  Input
%    opt    :  plot options
%  Output
%    c      :  maximum of value array or [] for truecolor array

if obj.truecolor
  c = [];
else
  c = max( subsref( obj, substruct( '()', { opt } ) ) );
end
