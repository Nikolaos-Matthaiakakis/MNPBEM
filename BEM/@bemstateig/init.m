function  obj = init( obj, p, varargin )
%  Initialize quasistatic BEM solver with eigenmode expansion.
%
%  Usage for obj = bemstatmirror :
%    obj = init( obj, p,       op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, [],   op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, enei, op, PropertyName, PropertyValue, ... )
%  Input
%    p    :  compound of particles (see comparticle)
%    enei :  light wavelength in vacuum
%    op   :  options 
%              additional fields of the option array can be passed as
%              pairs of PropertyName and Propertyvalue            

%  save particle
obj.p = p;

%  handle calls with and without ENEI
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ enei, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  Green function 
obj.g = compgreenstat( p, p, varargin{ : } );
%  surface derivative of Green function
F = subsref( obj.g, substruct( '.', 'F' ) );

%  options for BEM solver  
op = getbemoptions( { 'bemstateig' }, varargin{ : } );
%  number of eigenvalues
if isfield( op, 'nev' ),  obj.nev = op.nev;  else  obj.nev = 40;  end

%  eigenmode expansion
opts = struct( 'maxit', 1000, 'disp', 0 );
%  plasmon eigenmodes ( left and right eigenvectors )
[ ul, ~   ] = eigs( F.', obj.nev, 'sr', opts );  ul = ul .'; 
[ ur, ene ] = eigs( F  , obj.nev, 'sr', opts );
%  make eigenvectors orthogonal (needed for degenerate eigenvalues)
ul = ( ul * ur ) \ ul;    

%  unit matrices
unit = zeros( obj.nev ^ 2, p.np );
%  loop over unique material combinations
for i = 1 : p.np
  ind = p.index( i );
  unit( :, i ) = reshape( ul( :, ind ) * ur( ind, : ), obj.nev ^ 2, 1 );
end

%  save eigenmodes in BEM solver
[ obj.ur, obj.ul, obj.ene, obj.unit ] = deal( ur, ul, ene, unit );
%  initialize for given wavelength
if exist( 'enei', 'var' ) && ~isempty( enei )
  obj = subsref( obj, substruct( '()', { enei } ) );
end
