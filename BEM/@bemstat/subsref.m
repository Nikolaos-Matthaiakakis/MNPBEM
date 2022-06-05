function obj = subsref( obj, s )
%  Access to functions and class properties, and BEM solver initialization.
%
%  Usage for obj = bemstat :
%    obj.field( sig )       :  electric field
%    obj.potential( sig )   :  scalar potential
%    obj = obj( enei )      :  computes resolvent matrix for later use
%                                in mldivide 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        obj = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        obj = potential( obj, s( 2 ).subs{ : } );        
      otherwise
        obj = builtin( 'subsref', obj, s );
    end
    
  %  matrix for BEM solution        
  case '()'
    %  energy
    enei = cell2mat( s.subs ); 
    
    %  use previously computed matrices ?
    if isempty( obj.enei ) || obj.enei ~= enei
      %  inside and outside dielectric function
      eps1 = obj.p.eps1( enei );
      eps2 = obj.p.eps2( enei );
      %  Lambda [ Garcia de Abajo, Eq. (23) ]
      lambda = 2 * pi * ( eps1 + eps2 ) ./ ( eps1 - eps2 );
      
      %  BEM resolvent matrix  
      obj.mat = - inv( diag( lambda ) + obj.F );
      %  save energy
      obj.enei = enei;
    end
end
