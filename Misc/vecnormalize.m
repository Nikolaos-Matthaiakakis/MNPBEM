function v = vecnormalize( v, varargin )
%  VECNORMALIZE - Normalize vector array.
%
%  Usage :
%    v = vecnormalize( v )
%    v = vecnormalize( v, v2 )
%    v = vecnormalize( v,     'max'  )
%    v = vecnormalize( v, v2, 'max'  )
%    v = vecnormalize( v,     'max2' )
%    v = vecnormalize( v, v2, 'max2' )
%  Input
%    v      :  vector array of size (:,3,siz)
%    v2     :  normalize vector V using another vector array of same size
%    'max'  :  normalization using maximum of V or V2
%    'max'  :  normalization of v(:,:,i) for each i
%  Output
%    v      :  normalized vector array

%  deal with different inputs
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ v2, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end
if ~isempty( varargin ),  key = varargin{ 1 };  end
%  default values
if ~exist( 'v2', 'var'  ),  v2  = v;   end
if ~exist( 'key', 'var' ),  key = '';  end

%  size of array
siz = size( v );
%  norm
n = sqrt( dot( abs( v2 ), abs( v2 ), 2 ) );
%  normalization
switch key
  case 'max'
    v = v / max( n( : ) );
  case 'max2'
    siz2 = ones( size( siz ) );  siz2( 1 : 2 ) = siz( 1 : 2 );
    v = v ./ repmat( max( n, [], 1 ), siz2 );
  otherwise
    siz2 = ones( size( siz ) );  siz2( 2 ) = size( v, 2 );
    v = v ./  repmat( n, siz2 );
end
   