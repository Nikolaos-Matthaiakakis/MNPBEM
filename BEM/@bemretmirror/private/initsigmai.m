function [ Sigmai, obj ] = initsigmai( obj, x, y, z )
%  INITSIGMAI - Initialize Sigmai matrix for BEM solver (if needed).
%    Eq. (21,22) of Garcia de Abajo and Howie, PRB  65, 115418 (2002).
    

if ~isempty( obj.Sigmai{ x, y, z } )
  %  use previously computed value
  Sigmai = obj.Sigmai{ x, y, z };
  
else
  %  compute Sigmai
  
  %  wavenumber of light in vacuum and outer surface normal
  k    = obj.k;      
  nvec = obj.nvec; 
  %  outer product
  outer = @( i ) ( nvec( :, i ) * nvec( :, i )' );
  %  G1 * eps1 * G1i - G2 * eps2 * G2i
  L = { obj.L1{ x } - obj.L2{ x },  ...
        obj.L1{ y } - obj.L2{ y },  ...
        obj.L1{ z } - obj.L2{ z } };
  %  Eqs. (21,22)
  Sigma =  ...
        obj.Sigma1{ z } * obj.L1{ z } - obj.Sigma2{ z } * obj.L2{ z } +  ...
      k ^ 2 * ( ( L{ 1 } * obj.Deltai{ x } ) .* outer( 1 ) ) * L{ 3 } +  ...
      k ^ 2 * ( ( L{ 2 } * obj.Deltai{ y } ) .* outer( 2 ) ) * L{ 3 } +  ...
      k ^ 2 * ( ( L{ 3 } * obj.Deltai{ z } ) .* outer( 3 ) ) * L{ 3 };      
  %  inverse matrix
  Sigmai = inv( Sigma );
  
  %  save Sigmai
  obj.Sigmai{ x, y, z } = Sigmai;
end
