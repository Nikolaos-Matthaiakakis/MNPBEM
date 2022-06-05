function varargout = plot( obj, varargin )
%  PLOT - Plot polygon.
%
%  Usage for obj = polygon3 :
%    plot( obj,          )
%    plot( obj, LineSpec )

if numel( obj ) > 1
  for i = 1 : numel( obj )
    [ varargout{ 1 : nargout } ] = plot( obj( i ), varargin{ : } );  hold on;
  end
else
  %  polygon positions
  pos = obj.poly.pos;
  %  call PLOT3
  [ varargout{ 1 : nargout } ] =  ...
    plot3( pos( :, 1 ), pos( :, 2 ), 0 * pos( :, 1 ) + obj.z, varargin{ : } ); 
end
