function [ dmin, ind ] = distmin3( p, pos, cutoff )
%  DISTMIN3 - Minimum distace in 3D between particle faces and positions.
%  
%  Usage :
%    dmin = distmin( p, pos, cutoff )
%  Input
%    p          :  particle object
%    pos        :  positions 
%    cutoff     :  compute distances only correctly for dmin < cutoff
%  Output
%    dmin       :  minimum distance between particle faces and positions
%    ind        :  index to nearest neighbour

%  integration points for particle boundary
[ pos2, ~, iface2 ] = quad( p );
%  find integration points closest to POS and convert to face index
try
  %  on default we use the KNNSEARCH function of the statistics toolbox 
  ind = iface2( knnsearch( pos2, pos ) );
catch
  %  if the statistics toolbox is not available we use a less accurate
  %  approach that is slower and uses more memory
  warning( 'MNPBEM:statistics',  ...
    'Matlab statistics toolbox not available - use substitute for KNNSEARCH' );
  [ ~, ind ] = min( misc.pdist2( pos, p.pos ), [], 2 );
end
%  distance between centroids and positions along normal direction
%    sign of distance chosen positive if point located above face element
%    and negative otherwise
dmin = dot( pos - p.pos( ind, : ), p.nvec( ind, : ), 2 );

if exist( 'cutoff', 'var' ) && cutoff == 0
  return
elseif ~exist( 'cutoff', 'var' )
  %  default value for cutoff
  cutoff = Inf;  
end

%  loop over positions
for i = reshape( find( abs( dmin ) <= cutoff ), 1, [] )
  %  centroid position
  pos0 = p.pos( ind( i ), : );
  %  project positions onto plane perpendicular to NVEC
  x = dot( pos( i, : ) - pos0, p.tvec1( ind( i ), : ) );
  y = dot( pos( i, : ) - pos0, p.tvec2( ind( i ), : ) );
  %  faces and vertices
  faces = p.faces( ind( i ), : );
  verts = p.verts( faces( ~isnan( faces ) ), : );
  %  project vertices
  xv = sum( bsxfun( @times, bsxfun( @minus, verts, pos0 ), p.tvec1( ind( i ), : ) ), 2 );
  yv = sum( bsxfun( @times, bsxfun( @minus, verts, pos0 ), p.tvec2( ind( i ), : ) ), 2 );
  %  distance from point to polygon in 2D
  rmin = p_poly_dist( x, y, xv, yv );
  %  add to DMIN if point is located outside of polygon
  if rmin > 0
    dmin( i ) = sign( dmin( i ) ) * sqrt( dmin( i ) ^ 2 + rmin ^ 2 );
  end
end


%*******************************************************************************
% function:	p_poly_dist
% Description:	distance from pont to polygon whose vertices are specified by the
%              vectors xv and yv
% Input:  
%    x - point's x coordinate
%    y - point's y coordinate
%    xv - vector of polygon vertices x coordinates
%    yv - vector of polygon vertices x coordinates
% Output: 
%    d - distance from point to polygon (defined as a minimal distance from 
%        point to any of polygon's ribs, positive if the point is outside the
%        polygon and negative otherwise)
% Routines: p_poly_dist.m
% Revision history:
%    7/9/2006  - case when all projections are outside of polygon ribs
%    23/5/2004 - created by Michael Yoshpe 
% Remarks:
%*******************************************************************************
function d = p_poly_dist(x, y, xv, yv) 

% If (xv,yv) is not closed, close it.
xv = xv(:);
yv = yv(:);
Nv = length(xv);
if ((xv(1) ~= xv(Nv)) || (yv(1) ~= yv(Nv)))
    xv = [xv ; xv(1)];
    yv = [yv ; yv(1)];
    Nv = Nv + 1;
end

% linear parameters of segments that connect the vertices
A = -diff(yv);
B =  diff(xv);
C = yv(2:end).*xv(1:end-1) - xv(2:end).*yv(1:end-1);

% find the projection of point (x,y) on each rib
AB = 1./(A.^2 + B.^2);
vv = (A*x+B*y+C);
xp = x - (A.*AB).*vv;
yp = y - (B.*AB).*vv;

% find all cases where projected point is inside the segment
idx_x = (((xp>=xv(1:end-1)) & (xp<=xv(2:end))) | ((xp>=xv(2:end)) & (xp<=xv(1:end-1))));
idx_y = (((yp>=yv(1:end-1)) & (yp<=yv(2:end))) | ((yp>=yv(2:end)) & (yp<=yv(1:end-1))));
idx = idx_x & idx_y;

% distance from point (x,y) to the vertices
dv = sqrt((xv(1:end-1)-x).^2 + (yv(1:end-1)-y).^2);

if(~any(idx)) % all projections are outside of polygon ribs
   d = min(dv);
else
   % distance from point (x,y) to the projection on ribs
   dp = sqrt((xp(idx)-x).^2 + (yp(idx)-y).^2);
   d = min(min(dv), min(dp));
end

if(inpolygon(x, y, xv, yv)) 
   d = -d;
end
