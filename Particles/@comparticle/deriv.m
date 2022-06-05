function [ v1, v2, t1, t2 ] = deriv( obj, v )
%  DERIV - Tangential derivative of function defined on surface.
%
%  Usage for obj = comparticle :
%    [ v1, v2, vec1, vec2 ] = deriv( obj, v )
%  Input
%    v       :  function values given at vertices 
%  Output
%    v1, v2  :  derivatives along TVEC at boundary centroids
%    t1, t2  :  triangular or quadrilateral directions

[ v1, v2, t1, t2 ] = deriv( obj.pc, v );
