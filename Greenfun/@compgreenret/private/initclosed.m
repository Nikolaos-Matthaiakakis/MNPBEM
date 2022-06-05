function g = initclosed( g, p1, p2, varargin )
%  INITCLOSED - Deal with closed argument of COMPARTICLE objects.

%  full particle in case of mirror symmetry  
if any( strcmp( 'sym', fieldnames( p1 ) ) )
  full1 = p1.pfull;  
else
  full1 = p1;
end
%  for a closed particle the surface integral of - F should give 2 * pi
%  see R. Fuchs and S. H. Liu, Phys. Rev. B 14, 5521 (1976).
%
%  The following code has to deal with different scenarios, such as mirror
%  symmetry or additional boundaries in the closed argument, and is
%  somewhat difficult to understand.  In the future the following lines
%  should be rewritten to make things more transparent.  Possible
%  simplifications could be to remove mirror symmetry as well as the
%  consideration of additional boundaries in the closed argument.
if any( strcmp( 'closed', fieldnames( full1 ) ) ) &&  ...
                                    ( full1 == p2 ) && ~isempty( full1.closed{ : } )
  %  loop over particles
  for i = 1 : length( p1.p )
    %  index to particle faces
    ind = p1.index( i );
    %  select particle and closed particle surface
    part = p1.p{ i };
    [ full, dir, loc ] = closedparticle( p1, i );
    
    if ~isempty( full )
      if ~isempty( loc )
        %  use already computed Green function object
        f = fun( g, loc, ind, varargin{ : } );
      else
        %  set up Green function
        if ~isempty( varargin{ : } )
          gstat = greenstat( full, part, bemoptions( varargin{ : }, 'waitbar', 0 ) );
        else
          gstat = greenstat( full, part );
        end      
        %  sum over closed surface
        f = fun( gstat, varargin{ : } );
      end
      %  set diagonal elements of Green function
      if strcmp( g.deriv, 'norm' )
        g = diag( g, ind, - 2 * pi * dir - f .' );
      else
        g = diag( g, ind, bsxfun( @times, part.nvec, - 2 * pi * dir - f .' ) ); 
      end
    end
  end
end


function f = fun( g, varargin )
%  FUN - Sum over closed surface.
%
%  f = sum( diag( area1 ) * g.F * diag( 1 ./ area2 ), 1 )

p1 = g.p1;
p2 = g.p2;
%  deal with different calling sequences
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ ind1, ind2, varargin ] =  ...
    deal( varargin{ 1 }, varargin{ 2 }, varargin( 3 : end ) );
else
  [ ind1, ind2 ] = deal( 1 : p1.n, 1 : p2.n );
end

%  allocate output
f = [];
%  multiplication function
mul = @( x, y ) bsxfun( @times, x, y );

%  initialize slicer object
s = slicer( [ p1.n, p2.n ], ind1, ind2, varargin{ : } );
%  loop over slices
for i = 1 : s.n
  %  indices for slice
  [ ind, row, col ] = s( i );
  %  evaluate surface derivative of Green function
  switch class( g )
    case 'greenstat'
      F = reshape( eval( g, ind,    'F' ), [ numel( row ), numel( col ) ] );
    case 'greenret'
      F = reshape( eval( g, ind, 0, 'F' ), [ numel( row ), numel( col ) ] );
  end
  % sum over Green function elements
  f = [ f, sum( mul( p1.area( row ), mul( F, 1 ./ p2.area( col ) .' ) ), 1 ) ];
end
