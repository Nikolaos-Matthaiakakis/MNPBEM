classdef epstable
%  Interpolate from tabulated values of dielectric function.

  %%  Properties
  properties
    enei        %  wavelengths for tabulated dielectric function
    ni          %  spline : refractive index (real part)
    ki          %  spline : refractive index (imaginary part)
  end

  %%  Methods
  methods
  
    function obj = epstable( finp )
      %  Constructor for tabulated dielectric function.
      %
      %  Usage : 
      %    eps = epstable( finp )
      %
      %    finp must be an ASCII files with "ene n k" in each line
      %      ene  :   photon energy (eV)
      %      n    :   refractive index (real part)
      %      k    :   refractive index (imaginary part)
      %
      %    The following files are available :
      %      gold.dat, silver.dat            :  Johnson, Christy
      %      goldpalik.dat, silverpalik.dat
      %                     copperpalik.dat  :  Palik
      
      [ ene, n, k ] =  ...
          textread( finp, '%f %f %f', 'commentstyle', 'matlab' );
      
      units;
      %  change energies from eV to nm
      obj.enei = eV2nm ./ ene;
      %  spline for interpolation
      obj.ni = spline( obj.enei, n );
      obj.ki = spline( obj.enei, k );
    end

    function display( obj )
      %  Command window display.
      disp( 'epstable : ' );
      disp( struct( 'enei', obj.enei, 'ni', obj.ni, 'ki', obj.ki ) );
    end
    
  end

end
