function fun = refine( p, ind )
%  REFINE - Refine function to be passed to Green function initialization.
%    Green function elements for neighbour cover layer elements are refined
%    through polar integration.
% 
%  Usage : 
%    fun = coverlayer.refine( p, ind )
%  Input
%    p        :  COMPARTICLE object
%    ind      :  particle indices for refinement
%  Output
%    fun      :  refinement function for Green function initialization

%  symmetrize indices
ind = unique( [ ind; fliplr( ind ) ], 'rows' );
%  refinement function
fun = @( obj, g, f ) refun( obj, g, f, p, ind );


function [ g, f ] = refun( obj, g, f, p, ind )
%  REFUN - Refinement function for Green function initialization.

%  select between static and retarded Green functions
switch class( obj )
  case 'greenstat'
    [ g, f ] = coverlayer.refinestat( obj, g, f, p, ind );
  case 'greenret'
    [ g, f ] = coverlayer.refineret(  obj, g, f, p, ind );
  otherwise
    error( 'Class name unknown' );
end
