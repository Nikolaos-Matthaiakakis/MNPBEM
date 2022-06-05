function varargout = plot2( obj, varargin )
%  PLOT2 - Plot function for composite particles.
%
%  Usage for obj = comparticle :
%    plot2( obj,      'PropertyName', PropertyValue, ... )
%    plot2( obj, val, 'PropertyName', PropertyValue, ... )
%  PropertyName
%    EdgeColor      :  color of edges of surface elements
%    FaceAlpha      :  transparency of surface elements
%    FaceColor      :  nfaces x 3 vector of RGB colors
%    nvec           :  plot normal vetors or not (1 and 0)
%    vec            :  nfaces x 3 vector to be plotted
%    cone           :  nfaces x 3 vector to be plotted (cone plot)
%    color          :  color of vectors
%    scale          :  sale factor for vectors
%    sfun           :  scale length of cones with given function

[ varargout{ 1 : nargout } ] = plot2( obj.pc, varargin{ : } );
