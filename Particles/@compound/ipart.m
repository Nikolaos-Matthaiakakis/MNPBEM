function [ ipart, ind ] = ipart( obj, ind )
%  IPART - Find particle or point number and corresponding index.
%
%  Usage for obj = ipart :
%    [ ipart, ind ] = ipart( obj, ind )
%  Input
%    ind    :  index for compound object
%  Output
%    ipart  :  particle index (or indices)
%    ind    :  relative index for particle or points

siz = [ 0, cumsum( cellfun( @( p ) ( p.size ), obj.p( obj.mask ) ) ) ];

ipart = [];
for i = reshape( ind, 1, [] )
  ipart = [ ipart, find( i > siz, 1, 'last' ) ];
end

%  relative index
ind = ind - siz( ipart );
