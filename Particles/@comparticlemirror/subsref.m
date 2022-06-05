function varargout = subsref( obj, s )
%  Access to symmetry and comparticle properties.
%    Only the masked particles are considered.
%
%  Usage for obj = comparticlemirror :
%    obj.sym        :  symmetry key 'x', 'y', or 'xy'
%    obj.symtable   :  table with symmetry values
%    obj.property   :  access properties of particle

switch s( 1 ).type
  case '.'
    switch s( 1 ).subs                  
      %  symmetry properties and class functions
      case { 'sym', 'symtable', 'symindex', 'symvalue',  ...
             'pfull', 'closed', 'closedparticle', 'mask' }
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s ); 
      %  base class subsref              
      otherwise
      [ varargout{ 1 : nargout } ] = subsref@comparticle( obj, s );             
    end
   
end
