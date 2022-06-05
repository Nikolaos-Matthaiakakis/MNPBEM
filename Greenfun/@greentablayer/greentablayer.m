classdef greentablayer
  %  Green function for layer structure.
  %    GREENTABLAYER computes the reflected Green function and its
  %    derivatives for a layer structure, and saves the results for a
  %    rectangular mesh of radial and height values.  The stored values can
  %    then be used for interpolation with arbitrary radial and height
  %    values.

  %%  Properties

  properties
    layer       %  layer structure
    r           %  radial values for tabulation
    z1, z2      %  z-values for tabulation
    pos         %  structure with expanded r and z values
    G           %  table for Green function
    Fr, Fz      %  table for surface derivatives of Green functions
  end
  
  properties
    enei        %  wavelengths for precomputed Green function
    Gsav        %  precomputed Green function table 
    Frsav       %  precomputed tables for surface derivatives of 
    Fzsav       %    Green functions
  end
    
  %%  Methods  
  methods 
    function obj = greentablayer( varargin )
      %  Initialize Green function object for layer structure.
      %  
      %  Usage :
      %    obj = greentablayer( layer, tab )
      %  Input
      %    layer    :  layer structure
      %    tab      :  grids for tabulated r and z-values
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'greentablayer : ' );
      disp( struct( 'layer', obj.layer, 'r', obj.r,  'z1', obj.z1,  ...
             'z2', obj.z2, 'G', obj.G, 'Fr', obj.Fr, 'Fz', obj.Fz ) );
    end   
  end
 
end
