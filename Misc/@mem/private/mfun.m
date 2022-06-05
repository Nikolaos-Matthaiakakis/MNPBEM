function varargout = mfun( varargin )
%  MFUN - Set and get memory information.

persistent sav

%  initialize SAV structure
if isempty( sav ),  sav = struct( 'flag', 0, 'report', {{}} );  end

switch varargin{ 1 }
  case 'on'
    %  start reporting memory information
    %    works only for Windows platforms
    try
      [ ~ ] = memory;
      sav = struct( 'flag', 1, 'report', {{}} );
    catch
      sav.flag = 0;
    end
    
  case 'off'
    %  stop reporting memory information
    sav.flag = 0;
    
  case 'clear'
    %  clear memory report
    sav = struct( 'flag', sav.flag, 'report', {{}} );
    
  case 'get'
    %  get memory structure
    varargout{ 1 } = sav;
    
  case 'set'
    %  set memory information with string identifier
    if sav.flag 
      user = memory;
      sav.report( size( sav.report, 1 ) + 1, 1 : 2 ) =  ...
        { varargin{ 2 }, user.MemAvailableAllArrays };
    end
end