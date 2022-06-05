function [] = plot( obj, varargin )
%  PLOT - Plot polygon.
%
%  Usage for obj = polygon :
%    plot( obj,           'PropertyName', PropertyValue, ... )
%    plot( obj, LineSpec, 'PropertyName', PropertyValue, ... )
%  Input
%    obj    :  single object or array
%  PropertyName
%    'nvec'     :  plot also normal vectors
%    'scale'    :  scaling for normal vectors

if length( obj ) ~= 1
  for i = 1 : length( obj )
    plot( obj( i ), varargin{ : } );  hold on;
  end
  return
end

%  line specification
if mod( length( varargin ), 2 ) == 0
  LineSpec = 'b';
else
  LineSpec = varargin{ 1 };
  if length( varargin ) ~= 1;  varargin = varargin( 2 : end );  end
end


%  extract input
for i = 1 : 2 : length( varargin )
  switch varargin{ i }
    case 'nvec'
      nvec = varargin{ i + 1 };
    case 'scale'
      scale = varargin{ i + 1 };
  end
end

%  plot polygon
pos = obj.pos;

plot( [ pos( :, 1 ); pos( 1, 1 ) ],  ...
      [ pos( :, 2 ); pos( 1, 2 ) ], LineSpec );

%  normal vector
if exist( 'nvec', 'var' ) && nvec

  nvec = norm( obj );
  if ~exist( 'scale', 'var' );  scale = 1;  end
    
  hold on;
  quiver( pos( :, 1 ), pos( :, 2 ), nvec( :, 1 ), nvec( :, 2 ), scale );
    
end
