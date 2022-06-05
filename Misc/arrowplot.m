function varargout = arrowplot( pos, vec, varargin )
%  ARROWPLOT - Plot vectors at given positions using arrows.
%
%  Usage :
%    arrowplot( pos, vec, 'PropertyName', PropertyValue, ... )
%  Input
%    pos        :  positions where cones are plotted
%    vec        :  vectors to be plotted
%  PropertyName
%    fun        :  plot function
%    scale      :  scale factor for vectors
%    sfun       :  scaling function for vectors

%  plot cones using BEMPLOT class
h = plotarrow( bemplot.get( varargin{ : } ), pos, vec, varargin{ : } );
%  set ouput
[ varargout{ 1 : nargout } ] = deal( h );
