function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of dipole excitation for use in BEMSTATMIRROR.
%
%  Usage for obj = dipolestatmirror :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  COMPSTRUCT array which contains the surface derivative
%                  'phip' of the scalar potential, the last two dimensions
%                  of phip correspond to the positions and dipole moments

%  initialize mirror dipoles (if needed)
obj = init( obj, p );
%  compute surface derivatives of (mirror) dipoles
mirror = cellfun( @( dip ) subsref( dip( p, enei ),   ...
  substruct( '.', 'phip' ) ), obj.mirror, 'UniformOutput', false );

%  initialize COMPSTRUCTMIRROR object
exc = compstructmirror( p, enei, @( x ) full( obj, x ) );
%  function for COMPSTRUCT objects
fun = @( phip, val )  ...
  compstruct( p, enei, 'symval', p.symvalue( val ), 'phip', phip );

switch obj.sym
  case 'x'
    exc.val{ 1 } = fun( mirror{ 1 } + mirror{ 2 }, { '-', '+', '+' } );
    exc.val{ 2 } = fun( mirror{ 1 } - mirror{ 2 }, { '+', '-', '-' } );
  case 'y'
    exc.val{ 1 } = fun( mirror{ 1 } + mirror{ 2 }, { '+', '-', '+' } );
    exc.val{ 2 } = fun( mirror{ 1 } - mirror{ 2 }, { '-', '+', '-' } );    
  case { 'xy' }
    exc.val{ 1 } = fun(   mirror{ 2 } + mirror{ 1 }  ...
                        + mirror{ 4 } + mirror{ 3 }, { '-+', '+-', '++' } );
    exc.val{ 2 } = fun( - mirror{ 2 } + mirror{ 1 }  ...
                        - mirror{ 4 } + mirror{ 3 }, { '++', '--', '-+' } );
    exc.val{ 3 } = fun(   mirror{ 2 } + mirror{ 1 }  ...
                        - mirror{ 4 } - mirror{ 3 }, { '--', '++', '+-' } );
    exc.val{ 4 } = fun( - mirror{ 2 } + mirror{ 1 }  ...
                        + mirror{ 4 } - mirror{ 3 }, { '+-', '-+', '--' } );                     
end
