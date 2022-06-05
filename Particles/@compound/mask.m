function obj = mask( obj, ind )
%  MASK - Mask out points or particles indicated by ind.
%
%  Usage for obj = compound :
%    obj = mask( obj, ind )

%  set on default mask to all points 
if ~exist( 'ind', 'var' ) || isempty( ind )
  ind = 1 : length( obj.p );
end

%  mask out gpoints or particles indicated by ind
obj.mask = ind;
obj.pc = vertcat( obj.p{ ind( : ) } );