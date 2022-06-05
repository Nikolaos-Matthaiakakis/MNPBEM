function  obj = init( obj, p, varargin )
%  Initialize quasistatic BEM solver with eigenmode expansion.
%
%  Usage for obj = bemstateigmirror :
%    obj = init( obj, p,       op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, [],   op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, enei, op, PropertyName, PropertyValue, ... )
%  Input
%    p    :  compound of particles (see comparticle)
%    enei :  light wavelength in vacuum
%    op   :  options 
%              additional fields of the option array can be passed as
%              pairs of PropertyName and Propertyvalue       
%  Initialize eigenmodes for BEM solver.

%  handle calls with and without ENEI
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ enei, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end
%  get options
op = getbemoptions( varargin{ : } );
%  save particle and number of eigenvalues
[ obj.p, obj.nev ] = deal( p, op.nev );

%  Green function
obj.g = compgreenstatmirror( p, p, op );
%  surface derivative of Green function
F = subsref( obj.g, substruct( '.', 'F' ) );

%%  eigenmode expansion
opts = struct( 'maxit', 1000, 'disp', 0 );

%  loop over symmetry values
for i = 1 : length( F )

  %  plasmon eigenmodes ( left and right eigenvectors )
  [ ul, ~   ] = eigs( F{ i }.', obj.nev, 'sr', opts );  ul = ul.'; 
  [ ur, ene ] = eigs( F{ i }  , obj.nev, 'sr', opts );
  %  make eigenvectors orthogonal (needed for degenerate eigenvalues)
  ul = ( ul * ur ) \ ul;    

  %  unit matrices
  unit = zeros( obj.nev ^ 2, p.np );
  %  loop over unique material combinations
  for ip = 1 : p.np
    ind = p.index( ip );
    unit( :, ip ) = reshape( ul( :, ind ) * ur( ind, : ), obj.nev ^ 2, 1 );
  end

  %  save eigenmodes in BEM solver
  obj.ur{ i } = ur;
  obj.ul{ i } = ul;

  obj.ene{  i } = ene;
  obj.unit{ i } = unit;
end

%%  initialize for given wavelength
if exist( 'enei', 'var' ) && ~isempty( enei )
  obj = subsref( obj, substruct( '()', { enei } ) );
end
