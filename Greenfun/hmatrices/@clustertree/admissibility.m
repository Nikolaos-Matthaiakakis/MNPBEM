function mat = admissibility( obj1, obj2, varargin )
%  ADMISSIBILITY - Admissibility matrix.
%
%  Usage for obj = clustertree :
%    mat = admissibility( obj1, obj2, op, PropertyPairs )
%    mat = admissibility( obj1, obj2,     PropertyPairs )
%  PropertyName
%    fadmiss  :  function for admissibility, @( rad1, rad2, dist )
%  Output
%    mat      :  admissibility matrix
%
%  See S. Boerm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003).

op = getbemoptions( varargin{ : }, { 'hoptions' } );
%  function for admissibility condition
if isfield( op, 'fadmiss' )
  fadmiss = op.fadmiss;
else
  fadmiss = @( rad1, rad2, dist ) 2.5 * min( rad1, rad2 ) < dist;
end

%  allocate matrix
mat = sparse( size( obj1.son, 1 ), size( obj2.son, 1 ) );
%  build block tree
mat = blocktree( mat, obj1, obj2, 1, 1, fadmiss );


function ad = admissible( obj1, obj2, i1, i2, fadmiss )
%  ADMISSIBLE - Check for admissibility.

if obj1.son( i1, 1 ) == 0 && obj2.son( i2, 1 ) == 0 
  %  leaf
  ad = 2;
else
  %  particle indices
  ip1 = ipart( obj1.p, obj1.ind( obj1.cind( i1, : ), 2 ) .' ); 
  ip2 = ipart( obj2.p, obj2.ind( obj2.cind( i2, : ), 2 ) .' );
  %  particle indices unique ?
  if ip1( 1 ) ~= ip1( 2 ) || ip2( 1 ) ~= ip2( 2 )
    ad = 0;
  else
    %  check for admissibility
    ad = fadmiss( obj1.rad( i1 ), obj2.rad( i2 ),  ...
                            norm( obj1.mid( i1, : ) - obj2.mid( i2, : ) ) );
  end
end


function ind = index( obj, i )
%  INDEX - Cluster index for leaves.

if obj.son( i, 1 ) == 0 
  ind = i;
else
  ind = obj.son( i, : );
end


function mat = blocktree( mat, obj1, obj2, i1, i2, fadmiss )
%  BLOCKTREE - Build block tree for matrix.

ad = admissible( obj1, obj2, i1, i2, fadmiss );
%  check for admissibility
if ad
  mat( i1, i2 ) = ad;
else
 [ ind1, ind2 ] = deal( index( obj1, i1 ), index( obj2, i2 ) );
  %  loop over sons
  for i1 = ind1
  for i2 = ind2
    mat = blocktree( mat, obj1, obj2, i1, i2, fadmiss );
  end
  end
end
