function [ p, close ] = getinput( p, varargin )
%  GETINPUT - Extract options for particles and get closed arguments.

%  split closed arguments and options
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ) || ischar( varargin{ i } )
    if ( i == 1 ) 
      close = {};  
      op = varargin;
    else
      close = varargin( 1 : i - 1 );
      op = varargin( i : end );
    end
    break;
  end
end
%  treat only closed argument in VARARGIN separately
if length( varargin ) == 1 && ~exist( 'close', 'var' ),  close = varargin;  end

%  default value for options and close argument
if ~exist( 'op', 'var' ) || isempty( op ),  op = { struct };  end
if ~exist( 'close', 'var' ),  close = {};  end
%  get BEM options
op = bemoptions( op{ : } );

%  loop over particles
for i = 1 : length( p )
  %  parameters for boundary integration  
  p{ i }.quad = quadface( op );
  %  curved particle boundary
  if isfield( op, 'interp' ) && strcmp( op.interp, 'curv' )
    p{ i } = curved( p{ i } );
  else
    p{ i } = flat( p{ i } );
  end
end
