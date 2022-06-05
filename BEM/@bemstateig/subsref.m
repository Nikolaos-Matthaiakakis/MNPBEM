function obj = subsref( obj, s )
%  Access to functions and class properties, and BEM solver initialization.
%
%  Usage for obj = bemstateig :
%    obj.field( sig )       :  call     field (see bemstateig/field)
%    obj.potential( sig )   :  call potential (see bemstateig/potential)
%    obj = obj( enei )      :  computes resolvent matrix for later use
%                                in mldivide 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type
    
%%  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case { 'field', 'fieldstat' }
        obj = field(     obj, s( 2 ).subs{ : } );
      case { 'potential', 'potentialstat' }
        obj = potential( obj, s( 2 ).subs{ : } );        
      otherwise
        obj = builtin( 'subsref', obj, s );
    end
    
%%  matrix for BEM solution        
  case '()'
    %  energy
    enei = cell2mat( s.subs ); 

    %  use previously computed matrices ?
    if isempty( obj.enei ) || obj.enei ~= enei
      %  dielectric function
      eps = cellfun( @( eps ) ( eps( enei ) ), obj.p.eps );
      %  inside and outside dielectric function
      eps1 = eps( obj.p.inout( :, 1 ) );
      eps2 = eps( obj.p.inout( :, 2 ) );
      %  Lambda [ Garcia de Abajo, Eq. (23) ]  
      Lambda = 2 * pi * ( eps1 + eps2 ) ./ ( eps1 - eps2 );
    
      %  BEM resolvent matrix 
      obj.mat = - obj.ur *                                       ...
          ( ( reshape( obj.unit * Lambda( : ), obj.nev, [] ) +   ...
                                             obj.ene ) \ obj.ul );
      %  save energy
      obj.enei = enei;
    end
                                           
end
