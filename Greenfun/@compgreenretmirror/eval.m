function g = eval( obj, varargin )
%  EVAL - Evaluate retarded Green function with mirror symmetry.
%
%  Deals with calls to obj = compgreenretmirror :
%    g = obj{ i, j }.G( enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%    enei   :  light wavelength in vacuum

%  pass input to COMPGREENRET
mat = subsref( obj.g, varargin{ : } );
%  symmetry table
tab = obj.p.symtable;

%  allocate output array
g = num2cell( zeros( 1, size( tab, 1 ) ) );

if min( size( mat ) ) ~= 1
  %  size of Green function matrix
  siz = size( mat );
  %  decompose Green matrix into sub-matrices
   
  if numel( siz ) == 2
    %  G, F, H1, H2
    mat = mat2cell( mat, siz( 1 ),  ...
                       repmat( siz( 1 ), siz( 2 ) / siz( 1 ), 1 ) );
  else
    %  Gp, H1p, H2p
    mat = mat2cell( mat, siz( 1 ), siz( 2 ),  ...
                       repmat( siz( 1 ), siz( 3 ) / siz( 1 ), 1 ) );
  end   
      
  %  contract Green function for different symmetry values
  for i = 1 : size( tab, 1 )
  for j = 1 : size( tab, 2 )
      g{ i } = g{ i } + tab( i, j ) * mat{ j };
  end
  end
end

    