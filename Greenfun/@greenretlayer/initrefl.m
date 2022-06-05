function obj = initrefl( obj, enei, ind )
%  INITREFL - Initialize reflected part of Green function.
%
%  Usage for obj = greenretlayer :
%    obj = initrefl( obj, enei )
%    obj = initrefl( obj, enei, ind )
%  Input
%    enei   :  wavelength of light in vacuum
%    ind    :  index to matrix elements to be computed
%  Output
%    obj    :  object with precomputed reflected Green functions

%  compute reflected Green functions only if not previously computed
if isempty( obj.enei ) || ( enei ~= obj.enei )
  %  save energy
  obj.enei = enei;
  %  compute reflected Green functions
  if ~exist( 'ind', 'var' )
    switch obj.deriv
      case 'norm'
        obj = initrefl1( obj, enei );
      case 'cart'
        obj = initrefl2( obj, enei );
    end
  else
    obj = initrefl3( obj, enei, ind );
  end
end
