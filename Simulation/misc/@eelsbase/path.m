function p = path( obj, medium )
%  PATH - Path length of electron beam propagating in different media.
%
%  Usage for obj = eelsbase :
%    p = path( obj, medium )
%  Input
%    medium     :  select given medium (optional)
%  Output
%    p          :  path lengths in different media

%  size of array
siz = [ numel( obj.p.eps ), size( obj.impact, 1 ) ];
%  put together path lengths
if isempty( obj.indmat )
  p = zeros( siz );  
else
  p = accumarray( {  ...
    obj.indmat, obj.indimp }, obj.z( :, 2 ) - obj.z( :, 1 ), siz );
end

if exist( 'medium', 'var' ),  p = p( medium, : );  end
