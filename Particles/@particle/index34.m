function [ ind3, ind4 ] = index34( obj, ind )
%  INDEX34 - Index to triangular and quadrilateral boundary elements.
%
%  Usage for obj = particle :
%    [ ind3, ind4 ] = index34( obj )
%    [ ind3, ind4 ] = index34( obj, ind )
%  Input
%    ind    :  index to specific boundary elements
%  Output
%    ind3   :  pointer to triangular face elements
%    ind4   :  pointer to quadrilateral face elements

if ~exist( 'ind', 'var' )
  ind3 = find(  isnan( obj.faces( :, 4 ) ) );
  ind4 = find( ~isnan( obj.faces( :, 4 ) ) );
else
  ind3 = find(  isnan( obj.faces( ind, 4 ) ) );
  ind4 = find( ~isnan( obj.faces( ind, 4 ) ) );
end
