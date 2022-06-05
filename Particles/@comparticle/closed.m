function obj = closed( obj, varargin )
%  Indicate closed surfaces of particles (for use in compgreen)
%
%  Usage for obj = comparticle :
%    obj = closed( obj, [ i1, i2, ... ] )  
%            closed surface of particles i1, i2, ...
%    obj = closed( obj, { i1, p1, p2, ... } )  
%            closed surface of particle i1 and particles p1, p2, ...

for i = 1 : length( varargin )
  %  input is index to particle(s) stored in obj
  if ~iscell( varargin{ i } )
    for ind = varargin{ i }
      %  set closed property if not previously set
      if isempty( obj.closed{ abs( ind ) } )
        obj.closed{ abs( ind ) } = varargin{ i };
      end
    end
  %  input is an additional particle
  else
    obj.closed{ varargin{ i }{ 1 } } =  ...
      vertcat( obj.p{ varargin{ i }{ 1 } }, varargin{ i }{ 2 : end } );
  end
end
