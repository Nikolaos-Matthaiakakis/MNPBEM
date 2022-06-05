function pot = potential( obj, p, enei )
%  POTENTIAL - Potential of plane wave excitation for use in bemretmirror.
%
%  Usage for obj = planewaveretmirror :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the scalar and vector
%                  potentials, as well as their surface derivatives

%  initialize COMPSTRUCTMIRROR object
pot = compstructmirror( p, enei, @( x ) full( obj, x ) );

%  external excitation
for i = 1 : 2
  
  %  light polarization
  pol = zeros( 2, 3 );  pol( :, i ) = 1;  
  %  light propagation direction
  dir = [ 0, 0, 1; 0, 0, - 1 ];
  
  exc = obj.exc;
  %  plane wave excitation
  [ exc.pol, exc.dir ] = deal( pol, dir );
  %  excitation
  pot.val{ i } = exc( p, enei );
  
end

%  add symmetry values
switch p.sym
  case 'x'
    pot.val{ 1 }.symval = p.symvalue( { '+', '-', '-' } );
    pot.val{ 2 }.symval = p.symvalue( { '-', '+', '+' } );
  case 'y'
    pot.val{ 1 }.symval = p.symvalue( { '+', '-', '+' } );
    pot.val{ 2 }.symval = p.symvalue( { '-', '+', '-' } );    
  case 'xy'
    pot.val{ 1 }.symval = p.symvalue( { '++', '--', '-+' } );
    pot.val{ 2 }.symval = p.symvalue( { '--', '++', '+-' } );
end

