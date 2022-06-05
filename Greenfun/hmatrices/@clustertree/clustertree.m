classdef clustertree
  %  Build cluster tree through bisection.
  % 
  %  See S. Boerm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003).
  
  %%  Properties   
  properties
    p           %  compound of discretized particles
    son         %  table of sons
  end
  
  properties
    mid         %  center position of bounding box
    rad         %  radius of bounding box
    ind         %  conversion between particle index and cluster index
    cind        %  cluster indices
    ipart       %  particle index (0 for composite particles)
  end
    
  %%  Methods
  methods
    function obj = clustertree( varargin )
      %  Initialize cluster tree.
      %
      %  Usage :
      %    obj = clustertree( p, op, PropertyPairs )
      %    obj = clustertree( p,     PropertyPairs )
      %  Input
      %    p        :  compound of particles
      %  PropertyName
      %    cleaf    :  threshold parameter for bisection
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'clustertree : ' );
      disp( struct( 'p', obj.p, 'son', obj.son ) );
    end
  end
    
end
