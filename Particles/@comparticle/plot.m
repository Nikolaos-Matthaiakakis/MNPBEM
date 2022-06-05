function varargout = plot( obj, varargin )
%  PLOT - Plot discretized particle surface or values given on surface.
%
%  Usage for obj = comparticle :
%    plot( obj,      'PropertyName', PropertyValue, ... )
%    plot( obj, val, 'PropertyName', PropertyValue, ... )
%  Input
%    val            :  value array
%  PropertyName
%    EdgeColor      :  color of edges of surface elements
%    FaceAlpha      :  transparency of surface elements
%    FaceColor      :  nfaces x 3 vector of RGB colors
%    nvec           :  plot normal vetors or not (1 and 0)
%    vec            :  vector or vector array to be plotted
%    cone           :  vector or vector array to be plotted (cone plot)
%    color          :  color of vectors
%    fun            :  plot function
%    scale          :  sale factor for vectors
%    sfun           :  scale length of cones with given function

[ varargout{ 1 : nargout } ] = plot( obj.pc, varargin{ : } );
