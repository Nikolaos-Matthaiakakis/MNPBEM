function varargout = eval1( obj, k, varargin )
%  EVAL - Evaluate Green function.
%
%  Usage for obj = greenret :
%    varargout = eval1( obj, k, key1, key2, ... )
%  Input
%    k      :  wavenumber
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

%  Green function
if any( strcmp( 'G', varargin ) )
  %  Green function
  G = 1 ./ d * area;
  %  refine Green function
  if ~isempty( obj.ind )
    G( obj.ind ) = obj.g * transpose( ( 1i * k ) .^ ( 0 : obj.order ) );
  end
  G = reshape( G, [ n1, n2 ] ) .* exp( 1i * k * d );
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
      F = ( in( x, 1 ) + in( y, 2 ) + in( z, 3 ) ) .*  ...
                               ( 1i * k - 1 ./ d ) ./ d .^ 2 * area;
      if ~isempty( obj.ind )
        F( obj.ind ) = obj.f * transpose( ( 1i * k ) .^ ( 0 : obj.order ) );
      end
      F = reshape( F, [ n1, n2 ] ) .* exp( 1i * k * d );    
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
      %  use derivative of Green function
      if any( strcmp( 'Gp',  varargin ) ) ||   ...
         any( strcmp( 'H1p', varargin ) ) ||  any( strcmp( 'H2p', varargin ) )
        %  auxiliary quantity
        f = ( 1i * k - 1 ./ d ) ./ d .^ 2;
        %  derivative of Green function
        Gp = cat( 3, ( f .* x ) * area, ( f .* y ) * area, ( f .* z ) * area );
        %   full derivative of Green function
        Gp = reshape( Gp, [], 3 );
        if ~isempty( obj.ind )
          Gp( obj.ind, : ) = matmul( obj.f, transpose( ( 1i * k ) .^ ( 0 : obj.order ) ) );
        end
        %  multiply with phase factor
        Gp = bsxfun( @times, Gp, reshape( exp( 1i * k * d ), [], 1 ) );
        %  reshape Green function
        Gp = permute( reshape( Gp, n1, n2, 3 ), [ 1, 3, 2 ] );
        %  compute surface derivative of Green function ?
        if any( strcmp( 'F', varargin ) ) || any( strcmp( 'H1', varargin ) )  ...
                                          || any( strcmp( 'H2', varargin ) )
          F = inner( obj.p1.nvec, Gp );
        end
    
      %  compute only surface derivative of Green function
      else
        %  auxiliary quantity
        f = ( 1i * k - 1 ./ d ) ./ d .^ 2;
        %  surface derivative of Green function
        F = ( bsxfun( @times, f .* x, obj.p1.nvec( :, 1 ) ) +  ...
              bsxfun( @times, f .* y, obj.p1.nvec( :, 2 ) ) +  ...
              bsxfun( @times, f .* z, obj.p1.nvec( :, 3 ) ) ) * area;
        %  index to surface elements to be refined
        [ i, ~ ] = ind2sub( size( d ), obj.ind );
        %  refine surface derivative of Green function
        F( obj.ind ) = inner( obj.p1.nvec( i, : ), obj.f ) *  ...
                                     transpose( ( 1i * k ) .^ ( 0 : obj.order ) );
        %  reshape Green function and multiply with phase factor
        F = reshape( F, size( d ) ) .* exp( 1i * k * d );     
      end  
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
