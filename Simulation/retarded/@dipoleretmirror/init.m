function obj = init( obj, p )
%  INIT - Initialize mirror dipoles.

if isempty( obj.sym ) || ~strcmp( obj.sym, p.sym ) 
  %  set symmetry value
  obj.sym = p.sym;
  
  %  dipole position
  pt = obj.dip.pt;  
  %  set dipoles
  mirror{ 1 } = dipoleret( pt, [ 1, 0, 0; 0, 1, 0; 0, 0, 1 ] );
  
  switch obj.sym
    case 'x'
      mirror{ 2 } = dipoleret( flip( pt, 1 ), [ - 1, 0, 0; 0,   1, 0; 0, 0, 1 ] );
    case 'y'
      mirror{ 2 } = dipoleret( flip( pt, 2 ), [   1, 0, 0; 0, - 1, 0; 0, 0, 1 ] ); 
    case 'xy'
      mirror{ 2 } = dipoleret( flip( pt, 1 ), [ - 1, 0, 0; 0,   1, 0; 0, 0, 1 ] );
      mirror{ 3 } = dipoleret( flip( pt, 2 ), [   1, 0, 0; 0, - 1, 0; 0, 0, 1 ] );
      mirror{ 4 } = dipoleret( flip( pt, [ 1, 2 ] ),  ...
                                              [ - 1, 0, 0; 0, - 1, 0; 0, 0, 1 ] );
  end
  
  %  save mirror dipoles
  obj.mirror = mirror; 
end
