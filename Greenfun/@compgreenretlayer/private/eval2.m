function g = eval2( obj, i1, i2, key, enei, ind )
%  EVAL2 - Evaluate Green function for selected matrix elements.
%
%  Usage for obj = compgreenretlayer :
%    varargout = eval2( obj, i1, i2, enei, key, ind )
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
%    ind    :  index to selected matrix elements

%  compute Green functions
g = eval( obj.g, i1, i2, key, enei, ind );
%  make sure that G is not zero
if numel( g ) == 1 && g == 0,  g = zeros( obj.p1.n, obj.p2.n );  end

%  Green function for outer surfaces
if i1 == size( obj.p1.inout, 2 ) && i2 == 2
  %  rows and columns of selected matrix elements
  [ row, col ] = ind2sub( [ obj.p1.n, obj.p2.n ], ind );
  %  The reflected Green function is only computed for boundary elements
  %  connected to the layer structure (see INIT).  In the following we (i)
  %  determine which elements of IND are connected to the layer structure,
  %  and (ii) determine the indices for calling GREENRETLAYER.
  [ ~, i1 ] = ismember( row, obj.ind1 );
  [ ~, i2 ] = ismember( col, obj.ind2 );
  %  boundary elements connected through layer structure
  ilayer = i1 & i2;
  [ i1, i2 ] = deal( i1( ilayer ), i2( ilayer ) );
  %  convert subscripts to linear indices
  ind1 = sub2ind( [ obj.gr.p1.n, obj.gr.p2.n ], i1, i2 );
  
  %  initialize reflected part of Green function
  obj = initrefl( obj, enei, ind1 );
  %  add reflected Green function
  switch key
    case 'G'
      g = assembly( g, obj.gr.G, ilayer );
    case { 'F', 'H1', 'H2' }
      g = assembly( g, obj.gr.F, ilayer );
  end
end


function G = assembly( g, gr, ind )
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
  G.( names{ i } )( ind ) =   ...
  G.( names{ i } )( ind ) + gr.( names{ i } );
end
