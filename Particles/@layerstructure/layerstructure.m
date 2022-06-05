classdef layerstructure
  %  Dielectric layer structures.
  %    The outer surface normals of the layers must point upwards.  
  %    We assume a geometry of the following form:
  %
  %              eps{ 1 }
  %    --------------------------  z( 1 )
  %              eps{ 2 }
  %    --------------------------  z( 2 )
  %               ...
  %    --------------------------  z( end )
  %              eps{ end }
  
%%  Properties
  properties
    eps             %  cell array of dielectric functions
    z               %  z-positions of layers
    ind             %  index to table of dielectric functions
  end
  
  properties
    ztol = 2e-2     %  tolerance for detecting points in layer
    rmin = 1e-2     %  minimum radial distance for Green function
    zmin = 1e-2     %  minimum distance to layer for Green function
    semi = 0.1      %  imaginary part of semiellipse for complex integration
    ratio = 2       %  z : r ratio which determines integration path
    op              %  options for ODE integration    
  end
  
%%  Methods
  methods
    function obj = layerstructure( epstab, ind, z, varargin )
      %  Set properties of layer structure
      %
      %  Usage :
      %    obj = layerstructure( epstab, ind, z, 'PropertyName', PropertyValue )
      %    obj = layerstructure( epstab, ind, z,  options )
      %  Input
      %    epstab   :  cell array of dielectric functions
      %    ind      :  index to dielectric functions of layer structure
      %    z        :  z-position(s) of layers
      %    options  :  struct with options
      %  PropertyName
      %    ztol     :  tolerance for detecting points in layer
      %    semi     :  imaginary part of semiellipse for complex
      %                integration (default is 0.1)
      %    ratio    :  z : r ratio which determines integration path via
      %                Bessel (z<ratio*r) or Hankel functions
      %    op       :  options for ODE integration
      
      [ obj.eps, obj.ind, obj.z ] = deal( epstab( ind ), ind, z );
      %  save additional arguments
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'layerstructure : ' );
      disp( struct( 'eps', { obj.eps }, 'z', obj.z ) );
    end   
  end
  
  methods (Static)
    op = options( varargin );
  end
  
end