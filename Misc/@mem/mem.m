classdef mem
  %  Memory information (used for testing).
  %
  %  Works under Windows in order to monitor the memory usage of Matlab.
  %
  %  mem.on;
  %  mem.set( 'key1' );
  %  a = zeros( 1000 );
  %  ...
  %  mem.set( 'key2' );
  %  ...
  %  mem.off;
  %  print( mem );
 
  methods
    function disp( ~ )
      %  Command window display.
      disp( mfun( 'get' ) );
    end    
  end
  
  methods (Static)
        
    function on
      %  ON - Start reporting memory information.
      mfun( 'on' );
    end
    
    function off
      %  OFF - STOP reporting memory information.
      mfun( 'off' );
    end
    
    function clear
      %  CLEAR - Clear memory report.
      mfun( 'clear' );
    end  
    
    function set( varargin )
      %  SET - Set memory information with string identifier.
      if isempty( varargin ),  varargin = { '' };  end
      mfun( 'set', varargin{ : } );
    end
    
    function varargout = flag
      %  FLAG - Get flag.
      m = mfun( 'get' );
      varargout{ 1 } = m.flag;
    end    
    
    function varargout = report
      %  REPORT - Get report cell array.
      m = mfun( 'get' );
      varargout{ 1 } = m.report;
    end
    
  end
end
