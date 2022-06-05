function opt = options( varargin )
%  OPTIONS - Set options or use default options for layer structure.
%    The integration path in the complex plane is chosen according to 
%    M. Paulus et al., PRE 62, 5797 (2000).
%
%  Usage  :
%    op = layerstructure.options(     PropertyPairs )
%    op = layerstructure.options( op, PropertyPairs )
%  Input
%    op         :  option structure
%  PropertyName
%    ztol       :  tolerance for detecting points in layer
%    rmin       :  minimum radial distance for Green function
%    zmin       :  minimum distance to layers for Green function
%    semi       :  imaginary part of semiellipse for complex integration
%    ratio      :  z : r ratio which determines integration path
%    op         :  options for ODE integration

%  deal with first argument
if ~isempty( varargin ) && isstruct( varargin{ 1 } )
  [ opt, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end
%  set default values
if ~exist( 'opt', 'var' )
  opt.ztol  = 2e-2;     %  tolerance for detecting points in layer
  opt.rmin  = 1e-2;     %  minimum radial distance for Green function
  opt.zmin  = 1e-2;     %  minimum distance to layers for Green function  
  opt.semi  = 0.1;      %  imaginary part of semiellipse for complex integration
  opt.ratio = 2;        %  z : r ratio which determines integration path
  opt.op = odeset( 'AbsTol', 1e-6, 'InitialStep', 1e-3 );  
                        %  options for ODE integration
end

%  get options
op = getbemoptions( varargin{ : } );
%  options names
names = fieldnames( op );

for i = 1 : length( names )
  if any( strcmp( { 'ztol', 'rmin', 'zmin', 'semi', 'ratio', 'op' }, names{ i } ) )
    %  set user-definded values
    opt.( names{ i } ) = op.( names{ i } );
  end
end
