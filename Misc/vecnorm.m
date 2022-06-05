function n = vecnorm( v, key )
%  VECNORM - Norm of vector array.
%
%  Usage :
%    n = vecnorm( v )
%    n = vecnorm( v, 'max' )
%  Input
%    v      :  vector array of size (:,3,siz)
%  Output
%    n      :  norm array of size (:,siz) 
%                or maximum of N if 'max' set

n = squeeze( sqrt( dot( abs( v ), abs( v ), 2 ) ) );

%  maximum of N for 'max' keyword
if exist( 'key', 'var' ) && strcmp( key, 'max' ),  n = max( n( : ) );  end
