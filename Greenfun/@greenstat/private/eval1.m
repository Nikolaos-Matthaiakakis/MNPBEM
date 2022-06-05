function varargout = eval1( obj, varargin )
%  EVAL1 - Evaluate Green function.
%
%  Usage for obj = greenstat :
%    varargout = eval1( obj, key1, key2, ... )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%  Output
%    varargout  :  requested Green functions


%  positions and number of positions
pos1 = obj.p1.pos;  n1 = size( pos1, 1 );
pos2 = obj.p2.pos;  n2 = size( pos2, 1 );
%  area
area = spdiag( reshape( obj.p2.area, 1, [] ) );

%  difference of positions
x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 )' );
y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 )' );
z = bsxfun( @minus, pos1( :, 3 ), pos2( :, 3 )' );
%  distance
d = max( sqrt( x .^ 2 + y .^ 2 + z .^ 2 ), eps );

if any( strcmp( 'G', varargin ) )
  %  Green function
  G = 1 ./ d * area;
  %  refine Green function
  if ~isempty( obj.ind ),  G( obj.ind ) = obj.g;  end
  G = reshape( G, [ n1, n2 ] );
end

switch obj.deriv 
  case 'norm'
    %  only normal (surface) derivative of Green function
    if ~all( strcmp( 'G', varargin ) )
      %  normal vector
      nvec = obj.p1.nvec;
      %  inner product
      in = @( x, i ) bsxfun( @times, x, nvec( :, i ) ); 
      %  surface derivative of Green function
      F = - ( in( x, 1 ) + in( y, 2 ) + in( z, 3 ) ) ./ d .^ 3 * area;
      %  refine surface derivative of Green function
      if ~isempty( obj.ind ),  F( obj.ind ) = obj.f;  end
      F = reshape( F, [ n1, n2 ] );
    end
    
    clear x y z

    %  reset diagonal elements of D
    d( d == eps ) = 0;
    %  allocate output
    varargout = cell( length( varargin ) );
    %  assign output
    for i = 1 : length( varargin )
      switch varargin{ i }
        case 'G'
          varargout{ i } = G;
        case 'F'
          varargout{ i } = F;
        case 'H1'
          varargout{ i } = F + 2 * pi * ( d == 0 );
        case 'H2'
          varargout{ i } = F - 2 * pi * ( d == 0 );
        case { 'Gp', 'H1p', 'H2p' }
          error( 'only surface derivative computed' );
        case 'd'
          varargout{ i } = d;
      end
    end
    
  case 'cart'
    %  Cartesian derivatives of Green function
    if ~all( strcmp( 'G', varargin ) )
      %  derivative of Green function
      Gp = - cat( 3, x ./ d .^ 3 * area, y ./ d .^ 3 * area, z ./ d .^ 3 * area );
      %   refine derivative of Green function
      Gp = reshape( Gp, [], 3 );
      if ~isempty( obj.ind ),  Gp( obj.ind, : ) = obj.f;  end
      Gp = permute( reshape( Gp, n1, n2, 3 ), [ 1, 3, 2 ] );
    end

    clear x y z

    %  reset diagonal elements of D
    d( d == eps ) = 0;    
    %  allocate output
    varargout = cell( length( varargin ) );
    %  assign output
    for i = 1 : length( varargin )
      switch varargin{ i }
        case 'G'
          varargout{ i } = G;
        case 'F'
          varargout{ i } = inner( obj.p1.nvec, Gp );
        case 'H1'
          varargout{ i } = inner( obj.p1.nvec, Gp ) + 2 * pi * ( d == 0 );
        case 'H2'
          varargout{ i } = inner( obj.p1.nvec, Gp ) - 2 * pi * ( d == 0 );
        case 'Gp'
          varargout{ i } = Gp;
        case 'H1p'
          varargout{ i } = Gp + 2 * pi * outer( obj.p1.nvec, d == 0 );
        case 'H2p'
          varargout{ i } = Gp - 2 * pi * outer( obj.p1.nvec, d == 0 );          
        case 'd'
          varargout{ i } = d;          
      end
    end
    
end
