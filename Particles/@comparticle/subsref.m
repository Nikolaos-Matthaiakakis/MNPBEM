function varargout = subsref( obj, s )
%  Access to closed and particle properties of compound objects.
%    Only the masked particles are considered.
%
%  Usage for obj = comparticle :
%    obj.closed     :  index for closed surfaces
%    obj.property   :  access properties of particle

switch s( 1 ).type
    
  case '.'
    switch s( 1 ).subs             
      %  masked class variables
      case 'closed'
        varargout{ 1 }  = subarray( obj.closed( obj.mask ), s );                   
    %  base class subsref      
    otherwise
      [ varargout{ 1 : nargout } ] = subsref@compound( obj, s );             
    end
   
end
