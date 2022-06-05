function varargout = interp( obj, varargin )
%  INTERP - Interpolate value from faces to vertices (or vice versa).
%
%  Usage for obj = comparticle :
%    [ vi, mat ] = interp( obj, v, key )
%  Input
%    v      :  array or structure with values given at faces/vertices 
%    key    :  interpolation method 'area' (default) or 'pinv'
%  Output
%    vi     :  values at vertices/faces 
%    mat    :  interpolation matrix

[ varargout{ 1 : nargout } ] = interp( obj.pc, varargin{ : } );
