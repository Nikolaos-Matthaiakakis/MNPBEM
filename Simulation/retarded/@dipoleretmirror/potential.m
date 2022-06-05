function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of dipole excitation for use in BEMRETMIRROR.
%
%  Usage for obj = dipoleretmirror :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  COMPSTRUCTMIRROR arrays which contain the scalar and vector
%                  potentials, the last two dimensions of the exc fields
%                  correspond to the positions and dipole moments

%  initialize mirror dipoles (if needed)
obj = init( obj, p );
%  compute surface derivatives of (mirror) dipoles
mirror = cellfun( @( dip ) dip( p, enei ), obj.mirror, 'UniformOutput', false );

%  initialize COMPSTRUCTMIRROR object
exc = compstructmirror( p, enei, @( x ) full( obj, x ) );
%  function for COMPSTRUCT objects
fun = @( mirror, val ) set( mirror, 'symval', p.symvalue( val ) );

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
