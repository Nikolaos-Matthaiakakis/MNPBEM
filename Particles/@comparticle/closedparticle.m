function [ p, dir, loc ] = closedparticle( obj, ind )
%  Return particle with closed surface for indexed particle.
%
%  Usage for obj = comparticle :
%    [ p, dir, ind ] = closedparticle( obj, ind )
%  Input
%    obj        :  compound of particles
%    ind        :  index to given particle
%  Output
%    p          :  closed particle ([] if not closed)
%    dir        :  outer (dir=1) or inner (dir=-1) surface normal
%    loc        :  if closed particle is contained in p, loc points to the
%                  elements of the closed particle (loc=[] otherwise)

if isempty( obj.closed{ ind } )
  [ p, dir, loc ] = deal( [], [], [] );
elseif isa( obj.closed{ ind }, 'particle' )
  [ p, dir, loc ] = deal( obj.closed{ ind }, 1, [] );
else
  closed = obj.closed{ ind };
  dir  = sign( closed( abs( closed ) == ind ) );
  %  put together closed particle surface
  p = obj.p( abs( closed ) );
  for i = find( sign( closed ) ~= dir )
    p{ i } = flipfaces( p{ i } );
  end
  p = vertcat( p{ : } );
  %  index to closed particle
  if all( closed > 0 )
    [ is, loc ] = ismember( p.pos, obj.pc.pos, 'rows' );
    if ~all( is ),  loc = [];  end
  else
    loc = [];
  end
end
