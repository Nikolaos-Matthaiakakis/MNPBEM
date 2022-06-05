classdef compoint < compound
  %  Compound of points in a dielectric environment.
  %    Given a set of points, COMPOINT puts the particles into a dielectric
  %    environment such that they can be used by the COMPGREEN classes.
  
%%  Properties
  properties
    pin         %  COMPARTICLE object from initialization
    layer       %  layer structure
  end

  properties (Access = private)
    npos        %  number of positions
    ind         %  index to positions
  end

%%  Methods
  methods
    function obj = compoint( p, pos, varargin )
      %  Set properties of compoint.
      %    Given a comparticle p, COMPOINT groups pos into set of points
      %    that are located within the different dielectric media of p.
      %
      %  Usage :
      %    obj = compoint( p, pos, 'PropertyName', PropertyValue, ... )
      %  Input
      %    p            :  comparticle
      %    pos          :  positions of points
      %  PropertyName
      %    mindist      :  minimum distance of points to given particle
      %                      e.g. [ 1, 0, ... ]
      %    medium       :  mask out points in selected media
      obj = obj@compound( p.eps, {}, [] );
      %  initialization
      obj = init( obj, p, pos, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'compoint :' );
      disp(  ...
        struct( 'eps', { obj.eps }, 'p', { obj.p( obj.mask ) },  ...
                'inout', obj.inout( obj.mask ), 'mask', obj.mask ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, p, pos, varargin );
  end
  
end
