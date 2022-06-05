function obj = flip( obj, dir )
%  FLIP - Flip compoint object along given directions.
%
%  Usage for obj = compoint :
%    obj = flip( obj, dir )
%  Input
%    obj    :  compound of objects
%    dir    :  directions along which object is flipped (default dir = 1)
%  Output
%    obj    :  flipped compoint object

if ~exist( 'dir', 'var' ),  dir = 1;  end

for id = dir
for ip = 1 : length( obj.p )
  obj.p{ ip }.pos( :, id ) = - obj.p{ ip }.pos( :, id ); 
end
end

%  compound of points
obj.pc = vertcat( obj.p{ obj.mask } );
