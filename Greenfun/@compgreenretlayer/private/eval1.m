function g = eval1( obj, i1, i2, key, enei )
%  EVAL1 - Evaluate Green function.
%
%  Usage for obj = compgreenretlayer :
%    varargout = eval1( obj, i1, i2, enei, key )
%  Input
%    i1     :  inner/outer surface of P1
%    i2     :  inner/outer surface of P2
%    enei   :  light wavelength in vacuum
%    key    :  G    -  Green functions
%              F    -  surface derivatives of Green functions
%              H    -  F + 2 * pi
%              H    -  F - 2 * pi
%              Gp   -  derivatives of Green functions
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%  Output
%    g      :  requested Green functions

%  compute Green functions
g = eval( obj.g, i1, i2, key, enei );
%  make sure that G is not zero
if numel( g ) == 1 && g == 0
  switch key
    case { 'Gp', 'H1p', 'H2p' }
      g = zeros( obj.p1.n, 3, obj.p2.n );
    otherwise
      g = zeros( obj.p1.n,    obj.p2.n );
  end
end

%  Green function for outer surfaces
if i1 == size( obj.p1.inout, 2 ) && i2 == 2
  %  initialize reflected part of Green function
  obj = initrefl( obj, enei );
  %  add reflected Green function
  switch key
    case 'G'
      g = assembly( obj, g, obj.gr.G  );
    case { 'F', 'H1', 'H2' }
      g = assembly( obj, g, obj.gr.F  );
    case { 'Gp', 'H1p', 'H2p' }
      g = assembly( obj, g, obj.gr.Gp );  
  end
end


function G = assembly( obj, g, gr )
%  ASSEMBLY - Assemble free and reflected Green functions.

%  get field names
names = fieldnames( gr );
%  loop over names
for i = 1 : numel( names )
  switch names{ i }
    case { 'ss', 'hh', 'p' }
      G.( names{ i } ) = g;
    otherwise
      G.( names{ i } ) = g * 0;
  end
  if ndims( g ) == 2
    G.( names{ i } )( obj.ind1,    obj.ind2 ) =   ...
    G.( names{ i } )( obj.ind1,    obj.ind2 ) + gr.( names{ i } );
  else
    G.( names{ i } )( obj.ind1, :, obj.ind2 ) =   ...
    G.( names{ i } )( obj.ind1, :, obj.ind2 ) + gr.( names{ i } );    
  end
end
