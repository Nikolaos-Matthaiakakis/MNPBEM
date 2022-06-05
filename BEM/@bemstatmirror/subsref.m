function obj = subsref( obj, s )
%  Access to functions and class properties, and BEM solver initialization.
%
%  Usage for obj = bemstatmirror :
%    obj.field( sig )       :  call     field
%    obj.potential( sig )   :  call potential
%    obj = obj( enei )      :  computes resolvent matrix 

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
      
      for i = 1 : length( obj.F )
        %  BEM resolvent matrix  
        obj.mat{ i } = - inv( diag( lambda ) + obj.F{ i } ); 
      end
      %  save energy
      obj.enei = enei;
    end
end
