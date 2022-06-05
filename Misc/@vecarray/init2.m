function obj = init2( obj, vec, mode )
%  Initialization of VECARRAY.
%
%  Usage for obj = valarray :
%    obj = init2( obj, vec )
%    obj = init2( obj, vec, mode )
%  Input
%    vec    :  vector array
%    mode   :  'cone' or 'arrow'

obj.vec = vec;
%  set MODE property
if exist( 'mode', 'var' ),  obj.mode = mode;  end
