function op = bemoptions( varargin )
%  BEMOPTIONS - Set standard options for MNPBEM simulation.
%
%  Usage :
%    op = bemoptions
%    op = bemoptions(     PropertyName, PropertyValue )
%    op = bemoptions( op, PropertyName, PropertyValue )
%  Input
%    PropertyPair  :  option name and value to be added to option structure
%    op            :  option structure from previous call
%  Output
%    op            :  structure with standard or user-defined options

%  handle case that no OP structure is provided
if isempty( varargin ) || ~isstruct( varargin{ 1 } )
  op = struct;
  
  op.sim = 'ret';             %  retarded simulation on default
  op.waitbar = 1;             %  show progress of simulation
  op.RelCutoff = 3;           %  cutoff parameter for face integration
%   op.pinfty = trisphere( 256, 2 );
%                               %  unit sphere at infinity for spectra
  op.order = 5;               %  order for exp( 1i * k * r ) expansion 
  op.interp = 'flat';         %  particle surface interpolation
                              %    'flat' or 'curv'
else
  %  extract option structure
  [ op, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  add property pairs
for i = 1 : 2 : length( varargin )
  if ischar( varargin{ i + 1 } )
    eval( [ 'op.', varargin{ i }, '=''', varargin{ i + 1 }, ''';' ] );
  else
    ans = varargin{ i + 1 };
    eval( [ 'op.', varargin{ i }, '= ans;' ] );    
  end
end
