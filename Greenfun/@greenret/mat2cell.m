function obj = mat2cell( obj, p1, p2 )
%  MAT2CELL - Split Green function into cell array.
%
%  Usage for obj = greenret :
%    obj = mat2cell( obj, siz1, siz2 )
%  Input
%    p1   :  cell array of particles or points
%    p2   :  cell array of particles
%  Output
%    obj  :  cell array of split Green functions

%  get dimensions of points or particles 
siz1 = cellfun( @( p ) p.n, p1, 'uniform', 1 );
siz2 = cellfun( @( p ) p.n, p2, 'uniform', 1 );

refine = ~isempty( obj.ind );
%  Green function refinement ?
if refine
  %  get indices for submatrices (use BLOCKMATRIX class)
  [ sub, ind ] = ind2sub( blockmatrix( siz1, siz2 ), obj.ind );
  %  refined Green functions
  g = cellfun( @( ind ) obj.g( ind, : ), ind, 'uniform', 0 );
  %  refined surface derivative of Green function
  if ismatrix( obj.f )
    f = cellfun( @( ind ) obj.f( ind, :    ), ind, 'uniform', 0 );
  else
    f = cellfun( @( ind ) obj.f( ind, :, : ), ind, 'uniform', 0 );
  end
end

%  initialize cell array of Green functions
obj = repmat( { obj }, numel( siz1 ), numel( siz2 ) );

for i1 = 1 : numel( p1 )
for i2 = 1 : numel( p2 )
  %  set particles
  obj{ i1, i2 }.p1 = p1{ i1 };
  obj{ i1, i2 }.p2 = p2{ i2 };
  %  set Green function elements for refinement
  if refine
    obj{ i1, i2 }.ind = sub{ i1, i2 };
    obj{ i1, i2 }.g   =   g{ i1, i2 };
    obj{ i1, i2 }.f   =   f{ i1, i2 };
  end
end
end
