function [] = beminfo( varargin )
%  BEMINFO - Provide information for MNPBEM demo file.

%  pointer to message window
persistent h;

switch varargin{ 1 }
  case 'close'
    close( h );  h = [];  
  otherwise
    %  read input
    inp = finp( varargin{ 1 } );
    %  write text to message window
    if isempty( h )
      h = msgbox( inp, varargin{ 1 } );
      set( h, 'DeleteFcn', @( ~, ~ ) beminfo( 'close' ) );
    else
      set( h, 'Name', varargin{ 1 } );
      set( findobj( h, 'Tag', 'MessageBox' ), 'String', inp );
    end 
end



function inp = finp( filename )
%  FINP - Read leading lines of input file.

%  open file
fid = fopen( filename, 'r' );
%  read first line  and save input
tline = fgets( fid );
inp = tline( 3 : end );

while tline( 1 ) == '%'
  tline = fgets( fid );
  %  add text to INP
  if length( tline ) > 3
    inp = [ inp, tline( 3 : end ) ];
  else
    inp = [ inp, tline( 2 : end ) ];
  end  
end


