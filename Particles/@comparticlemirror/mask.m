function obj = mask( obj, ind )
%  MASK - Mask out particles indicated by ind.
%
%  Usage for obj = comparticlemirror :
%    obj = mask( obj, ind )

obj = mask@comparticle( obj, ind );

%  index to equivalent particles
ip = reshape( 1 : length( obj.pfull.p ), length( obj.p ), [] );
%  mask full particle
obj.pfull = mask( obj.pfull, reshape( ip( ind, : ), 1, [] ) );
