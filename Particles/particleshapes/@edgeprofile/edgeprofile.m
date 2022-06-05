classdef edgeprofile
  %  Profile of smoothed edge for use with TRIPOLYGON.
  %    Edge profile for a supercircle (d,z)=( cos(phi^e), sin(phi^e) ).
  
  %%  Properties
  properties
    pos         %  (z,d) values for edge profile
    z           %  z-values for extruding polygon
  end

  %%  Methods
  methods
    function obj = edgeprofile( varargin )
      %  Set profile of smoothed edge for use with TRIPOLYGON.
      %
      %  Usage :
      %    obj = edgeprofile
      %    obj = edgeprofile( height, nz, PropertyPair )      
      %    obj = edgeprofile( height,     PropertyPair )
      %    obj = edgeprofile( pos,     z, PropertyPair )
      % Input
      %    height   :  height of particle
      %    nz       :  number of z-values
      %    pos      :  (z,d) values for edge profile
      %    z        :  z-values for extruding polygon
      %  PropertyName
      %    'e'      :  exponent of supercircle
      %    'dz'     :  z in [ - height + dz, height - dz ] / 2 for d >= 0
      %    'min'    :  minimal z-value of edge profile
      %    'max'    :  maximal z-value of edge profile
      %    'center' :  central z-value of edge profile
      %    'mode'   :  '00', '10', '01', '11', '20', '02' with
      %                rounded (0), no (1) and partially rounded (2) edge
      obj = init( obj, varargin{ : } );
    end
      
    function display( obj )
      %  Command window display.
      disp( 'edgeprofile : ' );
      disp( struct( 'pos', obj.pos, 'z', obj.z ) );
    end     
    
    function varargout = plot( obj )
      %  PLOT - Plot edge profile.
      [ varargout{ 1 : nargout } ] =  ...
        plot( obj.pos( :, 1 ), obj.pos( :, 2 ), 'o-', 0 * obj.z, obj.z, 'r+' );
    end
  end
     
end
