function varargout = coneplot( pos, vec, varargin )
%  CONEPLOT - Plot vectors at given positions using cones.
%
%  Usage :
%    coneplot( pos, vec, 'PropertyName', PropertyValue, ... )
%  Input
%    pos        :  positions where cones are plotted
%    vec        :  vectors to be plotted
%  PropertyName
%    fun        :  plot function
%    scale      :  scale factor for vectors
%    sfun       :  scaling function for vectors

%  plot cones using BEMPLOT class
h = plotcone( bemplot.get( varargin{ : } ), pos, vec, varargin{ : } );
%  set ouput
[ varargout{ 1 : nargout } ] = deal( h );
