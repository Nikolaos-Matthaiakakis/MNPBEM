function obj = subsref( obj, s )
%  Access to functions and class properties, and BEM solver initialization.
%
%  Usage for obj = bemstateigmirror :
%    obj.field( sig )       :  call     field 
%    obj.potential( sig )   :  call potential 
%    obj = obj( enei )      :  compute resolvent matrix 

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
      %  dielectric function
      eps = cellfun( @( eps ) ( eps( enei ) ), obj.p.eps );
      %  inside and outside dielectric function
      eps1 = eps( obj.p.inout( :, 1 ) );
      eps2 = eps( obj.p.inout( :, 2 ) );
      %  Lambda [ Garcia de Abajo, Eq. (23) ]  
      Lambda = 2 * pi * ( eps1 + eps2 ) ./ ( eps1 - eps2 );
    
      for i = 1 : length( obj.ur )
        %  BEM resolvent matrix 
        obj.mat{ i } = - obj.ur{ i } *                                  ...
            ( ( reshape( obj.unit{ i } * Lambda( : ), obj.nev, [] ) +   ...
                                         obj.ene{ i } ) \ obj.ul{ i } );
      end
      %  save energy
      obj.enei = enei;
    end
    
end
