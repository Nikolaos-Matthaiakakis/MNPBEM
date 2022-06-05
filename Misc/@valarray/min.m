function c = min( obj, opt )
%  MIN - Minimum of VALARRAY.
%
%  Usage for obj = valarray :
%    c = min( obj, opt )
%  Input
%    opt    :  plot options
%  Output
%    c      :  minimum of value array or [] for truecolor array

if obj.truecolor
  c = [];
else
  c = min( subsref( obj, substruct( '()', { opt } ) ) );
end
