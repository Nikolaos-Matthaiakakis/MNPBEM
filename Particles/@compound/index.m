function ind = index( obj, ipart )
%  INDEX - Index to given set of particles.
%
%  Usage for obj = compound :
%    ind = index( obj, ipart )
%  Input
%    ipart  :  particle index (or indices)
%  Output
%    ind    :  index to points, faces etc. of compound object

siz = [ 0, cumsum( cellfun( @( p ) ( p.size ), obj.p( obj.mask ) ) ) ];

ind = [];
for i = ipart
  ind = [ ind, ( siz( i ) + 1 ) : siz( i + 1 ) ];
end
