function obj = subsref( obj, s )
%  Access to functions and class properties, and BEM solver initialization.
%
%  Usage for obj = bemstat :
%    obj.field( sig )       :  compute electric field
%    obj.potential( sig )   :  compute potential
%    obj = obj( enei )      :  computes resolvent matrix for later use
%                                in mldivide 
%                                enei is the light wavelength in vacuum

switch s( 1 ).type
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
    %  exctract energy
    enei = cell2mat( s.subs ); 
    
    %  use previously computed matrices ?
    if isempty( obj.enei ) || obj.enei ~= enei
      %  inside and outside dielectric function
      eps1 = spdiag( obj.p.eps1( enei ) );
      eps2 = spdiag( obj.p.eps2( enei ) );
      %  Green functions
      [ H1, H2 ] = eval( obj.g, enei, 'H1', 'H2' );
      %  BEM resolvent matrix  
      obj.mat = - inv( eps1 * H1 - eps2 * H2 ) * ( eps1 - eps2 );
      %  save energy
      obj.enei = enei;
    end
end
