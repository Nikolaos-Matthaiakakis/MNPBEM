function  p = trisphere( n, varargin )
%  Load points on sphere from file and perform triangulation.
%    Given a set of stored points on the surface of a sphere, 
%    TRISPHERE loads the points and performs a triangulation.
%    Sets of points which minimize the potential energy are from
%    http://www.maths.unsw.edu.au/school/articles/me100.html.
%
%  Usage :
%    p = trisphere( n, diameter )
%    p = trisphere( n, diameter, varargin )
%  Input
%    n         :  number of points for sphere triangulation
%    diameter  :  diameter of sphere
%    varargin  :  additional parameters to be passed to PARTICLE
%  Output
%    p         :  triangulated faces and vertices of sphere

%%  load data from file
%  saved vertex points
nsav = [ 32 60 144 169 225 256 289 324 361 400 441 484 529 576 625  ...
         676 729 784 841 900 961 1024 1225 1444 ];
     
%  find number closest to saved number
[ ~, ind ] = min( abs( nsav - n ) );
%  input file name
inp = [ 'sphere', num2str( nsav( ind ) ) ];

if n ~= nsav( ind )
  fprintf( 1, 'trisphere: loading %s from trisphere.mat\n', inp ); 
end

%  load data from file
load( 'trisphere.mat', '-regexp', inp );
eval( [ 'sphere = ', inp, ';' ] );

%%  make sphere
%  vertices
verts = [ double( sphere.x ), double( sphere.y ), double( sphere.z ) ];
%  face list
faces = sphtriangulate( verts );

%  diameter of sphere
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ diameter, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) ); 
else
  diameter = 1;
end
%  rescale sphere
verts = 0.5 * verts * diameter;

%  make particle
p = particle( verts, faces, 'norm', 'off' );

%%  vertices and faces for curved particle boundary
%  add midpoints
p = midpoints( p, 'flat' );
%  rescale vertices
verts2 = 0.5 * diameter *  ...
    bsxfun( @rdivide, p.verts2, sqrt( dot( p.verts2, p.verts2, 2 ) ) );
%  make particle including mid points 
p = particle( verts2, p.faces2, varargin{ : } );
