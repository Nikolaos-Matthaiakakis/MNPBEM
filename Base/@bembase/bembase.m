classdef bembase
  %  Abstract base class for MNPBEM classes.
  %    By providing a task name and a list of attributes, one can access
  %    different classes by setting option parameters.
  %
  %  Example :
  %    name = 'bemsolver'
  %    needs = { struct( 'sim', 'stat' ), 'nev' }
  %
  %  A possible problem of the present implementation is that it is not
  %  possible to use BEMBASE classes as superclasses for other BEMBASE
  %  classes, since the Constant attribute cannot be changed by the derived
  %  class.  A way around could be to change to Static methods, such as
  %
  %    function n = name,  n = 'bemsolver';  end
  %
  %  For the moment we have refrained from such an approach.
  
  properties (Abstract = true, Constant)
    name    %  task name
    needs   %  cell array of fieldnames that must be provided or set in 
            %  the option structure
  end
  
  methods (Static)
    class = find( varargin );
  end
  
end
    