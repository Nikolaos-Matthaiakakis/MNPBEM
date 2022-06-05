function tab = tabspace( obj, varargin )
%  TABSPACE - Compute suitable grids for tabulated r and z-values.
%
%  One can either set the range of r and z values manually, or obtain a
%  grid by providing the particles and compoint objects used in dipole
%  simulations or for the computation of electromagnetic fields.
%
%  Usage for obj = layerstructure :
%    tab = tabspace( obj, r, z1, z2, PropertyPair )
%    tab = tabspace( obj, p,         PropertyPair )
%    tab = tabspace( obj, p, pt,     PropertyPair )
%  Input
%    r        :  radial values [ rmin,  rmax,  nr ]
%    z1, z2   :  z-values      [ zmin,  zmax,  nz ]
%    p        :  particle or cell array of particles
%    pt       :  points   or cell array of points
%  PropertyName
%    'rmod'   :  'log' for logspace r-table (default) or 'lin' for linspace
%    'zmod'   :  'log' for logspace z-table (default) or 'lin' for linspace
%    'nr'     :  number of r-values for automatic grid
%    'nz'     :  number of z-values for automatic grid
%    'scale'  :  scale factor for automatic grid sizes
%    'range'  :  'full' for use full z-range starting at layer 
%                              bottom and/or top for automatic grid size
%    'output' :  graphical output of grids
%  Output
%    tab.r    :  tabulated radial values
%    tab.z1   :  tabulated z1-values
%    tab.z2   :  tabulated z2-values

if isnumeric( varargin{ 1 } )
  tab = tabspace1( obj, varargin{ : } );
else
  tab = tabspace2( obj, varargin{ : } );
end

