function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of plane wave excitation with mirror symmetry.
%
%  Usage for obj = planewavestatmirror :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the surface derivative
%                  'phip' of the scalar potential

%  initialize COMPSTRUCTMIRROR object
exc = compstructmirror( p, enei, @( x ) full( obj, x ) );
%  function for COMPSTRUCT objects
fun = @( val, pol )  ...
  compstruct( p, enei, 'symval', p.symvalue( val ), 'phip', - p.nvec * pol' );

switch p.sym
  case 'x'
    exc.val{ 1 } = fun( { '+', '-', '-' },  [ 1, 0, 0 ] );
    exc.val{ 2 } = fun( { '-', '+', '-' },  [ 0, 1, 0 ] );
  case 'y'
    exc.val{ 1 } = fun(  { '+', '-', '+' }, [ 1, 0, 0 ] );
    exc.val{ 2 } = fun(  { '-', '+', '-' }, [ 0, 1, 0 ] );
  case 'xy' 
    exc.val{ 1 } = fun( { '++', '--', '-+' }, [ 1, 0, 0 ] );
    exc.val{ 2 } = fun( { '--', '++', '+-' }, [ 0, 1, 0 ] );
end
