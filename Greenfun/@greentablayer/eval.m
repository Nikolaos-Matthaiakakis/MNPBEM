function obj = eval( obj, enei, key )
%  EVAL - Evaluate table of Green functions for given wavelength.
%
%  Usage for obj = greentablayer :
%    obj = eval( obj, enei        )
%    obj = eval( obj, enei, 'new' )
%  Input
%    enei   :  wavelength of light in vacuum
%    'new'  :  do not use precomputed Green functions
%  Output
%    obj    :  evaluated Green function table

%  compute Green functions
if isempty( obj.Gsav ) || ( exist( 'key', 'var' ) && strcmp( key, 'new' ) )
  [ obj.G, obj.Fr, obj.Fz, obj.pos ] =  ...
    green( obj.layer, enei, obj.r( : ), transpose( obj.z1( : ) ), obj.z2( : ) );
  
%  use precomputed Green functions  
else
  %  check for proper bounds of Green energy
  assert( enei >= min( obj.enei ) && enei <= max( obj.enei ) );
  
  %  get field names
  names = fieldnames( obj.Gsav );
  
  %  only single wavelength
  if numel( obj.enei ) == 1
    %  loop over names
    for i = 1 : length( names )
      %  perform interpolations
      obj.G.(  names{ i } ) = squeeze( obj.Gsav.(  names{ i } ) );
      obj.Fr.( names{ i } ) = squeeze( obj.Frsav.( names{ i } ) );
      obj.Fz.( names{ i } ) = squeeze( obj.Fzsav.( names{ i } ) );
    end
      
  %  perform interpolation
  else
    %  size of Green function matrix
    siz = size( obj.Gsav.( names{ 1 } ) );  
    %  interpolation function
    fun = @( g ) reshape( interp1(  ...
      obj.enei, reshape( g, numel( obj.enei ), [] ), enei ), siz( 2 : end ) );
  
    %  loop over names
    for i = 1 : length( names )
      %  perform interpolations
      obj.G.(  names{ i } ) = fun( obj.Gsav.(  names{ i } ) );
      obj.Fr.( names{ i } ) = fun( obj.Frsav.( names{ i } ) );
      obj.Fz.( names{ i } ) = fun( obj.Fzsav.( names{ i } ) );
    end
  end
end
