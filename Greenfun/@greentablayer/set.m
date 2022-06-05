function obj = set( obj, enei, varargin )
%  SET - Precompute Green function table for given wavelengths.
%
%  Usage for obj = greentablayer :
%    obj = set( obj, enei, PropertyPairs )
%  Input
%    enei               :  wavelengths of light in vacuum
%  PropertyPairs
%    'waitbar'          :  plot waitbar during initialization
%    'waitbarlimits'    :  limits for waitbar
%  Output
%    obj                :  precomputed Green function table

%  get options
op = getbemoptions( varargin{ : }, { 'greenretlayer' } );


iswaitbar = isfield( op, 'waitbar' ) && op.waitbar;
if iswaitbar
  if ~isfield( op, 'waitbarlimits' ),  op.waitbarlimits = [ 0, 1 ];  end
  %  waitbar function
  fun = @( ien ) op.waitbarlimits( 1 ) + ien / length( enei ) * diff( op.waitbarlimits );
  %  initialize waitbar
  multiWaitbar( 'Initializing greentablayer', fun( 0 ),  ...
                     'Color', [ 0.4, 0.1, 0.5 ], 'CanCancel', 'on' ); 
end

%  save wavelength table
obj.enei = enei;

%  loop over wavelengths
for ien = 1 : numel( enei )
  
  %  evaluate table of Green functions
  obj = eval( obj, enei( ien ), 'new' );
  
  if ien == 1
    %  get field names
    names = fieldnames( obj.G );
    %  size of Green function matrix
    siz = [ numel( enei ), size( obj.G.( names{ 1 } ) ) ];    
    
    for i = 1 : length( names )
      %  initialize Green functions
      obj.Gsav.(  names{ i } ) = zeros( siz );  
      obj.Frsav.( names{ i } ) = zeros( siz );
      obj.Fzsav.( names{ i } ) = zeros( siz );
    end
  end
  %  save Green functions
  for i = 1 : length( names )
    obj.Gsav.(  names{ i } )( ien, : ) = reshape( obj.G.(  names{ i } ), 1, [] );
    obj.Frsav.( names{ i } )( ien, : ) = reshape( obj.Fr.( names{ i } ), 1, [] );
    obj.Fzsav.( names{ i } )( ien, : ) = reshape( obj.Fz.( names{ i } ), 1, [] );      
  end
  
  %  update multiWaitbar
  if iswaitbar && multiWaitbar( 'Initializing greentablayer', fun( ien ) )
    multiWaitbar( 'CloseAll' );  
    error( 'Initilialization of greentablayer stopped' );
  end  
end

%  reshape arrays
for i = 1 : length( names )
  obj.Gsav.(  names{ i } ) = reshape( obj.Gsav.(  names{ i } ), siz );
  obj.Frsav.( names{ i } ) = reshape( obj.Frsav.( names{ i } ), siz );
  obj.Fzsav.( names{ i } ) = reshape( obj.Fzsav.( names{ i } ), siz );
end

%  close waitbar
if iswaitbar && op.waitbarlimits( 2 ) == 1
  multiWaitbar( 'Initializing greentablayer', 'Close' );  
  drawnow;
end  
  
