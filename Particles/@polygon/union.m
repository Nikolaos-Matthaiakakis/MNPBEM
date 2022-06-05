function [ upos, unet ] = union( obj )
%  Put together positions and connections of polygon(s) for use in mesh2d.
%
%  Usage for obj = polygon :
%    [ upos, unet ] = union( obj1, obj2, ... )
%  Output
%    upos   :  unified positions for use in mesh2d
%    cnet   :  unified network for use in mesh2d

upos = [];
unet = [];

%  loop over particles
for i = 1 : length( obj ) 
    
  pos = obj( i ).pos;
  net = [ 1 : size( pos, 1 ); 2 : size( pos, 1 ), 1 ]';
  
  unet = [ unet; size( upos, 1 ) + net ];
  upos = [ upos; pos ];  
  
end
