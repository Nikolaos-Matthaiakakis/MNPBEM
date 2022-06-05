function obj = init( obj, varargin )
%  INIT - Set options for complex integration.
%
%  Usage for obj = layerstructure :
%    obj = init( obj, 'PropertyName', PropertyValue )
%    obj = init( obj, options )
%  PropertyName
%    ztol     :  tolerance for detecting points in layer
%    rmin     :  minimum radial distance for Green function
%    zmin     :  minimum distance to layer for Green function
%    semi     :  imaginary part of semiellipse for complex integration
%    ratio    :  z : r ratio which determines integration path via
%                Bessel (z<ratio*r) or Hankel functions
%    op       :  options for ODE integration
%  Input
%    options  :  struct with options

%  options for layer structure
op = getbemoptions( { 'layer' }, varargin{ : } );


%  extract input
if isfield( op, 'ztol'  ),  obj.ztol  = op.ztol;   end
if isfield( op, 'rmin'  ),  obj.rmin  = op.rmin;   end
if isfield( op, 'zmin'  ),  obj.zmin  = op.zmin;   end
if isfield( op, 'semi'  ),  obj.semi  = op.semi;   end
if isfield( op, 'ratio' ),  obj.ratio = op.ratio;  end
if isfield( op, 'op'    ),  obj.op    = op.op;     end

%  default options for ODE integration
if isempty( obj.op )
  obj.op = odeset( 'AbsTol', 1e-6, 'InitialStep', 1e-3 );  
end
