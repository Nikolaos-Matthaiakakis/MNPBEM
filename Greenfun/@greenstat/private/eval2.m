function varargout = eval2( obj, ind, varargin )
%  EVAL - Evaluate Green function.
%
%  Usage for obj = greenstat :
%    varargout = eval2( obj, ind, key1, key2, ... )
%  Input
%    k      :  wavenumber
%    ind    :  index for matrix elements to be computed
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%  Output
%    varargout  :  requested Green functions

%  rows and columns of elements to be computed
[ row, col ] = ind2sub( [ obj.p1.n, obj.p2.n ], ind );
%  positions 
pos1 = obj.p1.pos( row, : );  
pos2 = obj.p2.pos( col, : );  
%  area
area = obj.p2.area( col, : );
%  distance
d = max( sqrt( sum( ( pos1 - pos2 ) .^ 2, 2 ) ), eps );

%  Green function elements with refinement
[ ~, ind1, ind2 ] = intersect( obj.ind, ind );

%  Green function
if any( strcmp( 'G', varargin ) )
  %  Green function
  G = 1 ./ d .* area;
  %  refine Green function
  if ~isempty( ind1 ),  G( ind2 ) = obj.g( ind1 );  end
end

switch obj.deriv 
  case 'norm'
    %  only normal (surface) derivative of Green function
    if ~all( strcmp( 'G', varargin ) )
      %  surface derivative of Green function
      F = - dot( obj.p1.nvec( row, : ), pos1 - pos2, 2 ) ./ d .^ 3 .* area;
      %  refine surface derivative of Green function      
      if ~isempty( ind1 ),  F( ind2 ) = obj.f( ind1 );  end  
    end

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
        %  derivative of Green function
        Gp1 = - ( pos1( :, 1 ) - pos2( :, 1 ) ) ./ d .^ 3 .* area;
        Gp2 = - ( pos1( :, 2 ) - pos2( :, 2 ) ) ./ d .^ 3 .* area;
        Gp3 = - ( pos1( :, 3 ) - pos2( :, 3 ) ) ./ d .^ 3 .* area;
        if ~isempty( ind1 )
          Gp1( ind2 ) = obj.f( ind1, 1 );
          Gp2( ind2 ) = obj.f( ind1, 2 );
          Gp3( ind2 ) = obj.f( ind1, 3 );
        end
        %  derivative of Green function
        Gp = cat( 2, Gp1, Gp2, Gp3 );
        %  compute surface derivative of Green function ?
        if any( strcmp( 'F', varargin ) ) || any( strcmp( 'H1', varargin ) )  ...
                                          || any( strcmp( 'H2', varargin ) )
          F = sum( obj.p1.nvec( row, : ) .* Gp, 2 );
        end
    
      %  compute only surface derivative of Green function
      else
        %  surface derivative of Green function
        F = - dot( obj.p1.nvec( row, : ), pos1 - pos2, 2 ) ./ d .^ 3 .* area;        
        if ~isempty( ind1 )
          F( ind2 ) = dot( obj.p1.nvec( row( ind2 ), : ), obj.f( ind1, : ), 2 );
        end     
      end  
    end

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
