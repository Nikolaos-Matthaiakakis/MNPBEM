function obj = closed( obj, varargin )
%  Indicate closed surfaces of particles for Green function evalualtion.
%
%  Usage for obj = comparticlemirror :
%    obj = closed( obj, [ i1, i2, ... ] )  
%            closed surface of particles i1, i2, ... together with the
%            equivalent particles generated through mirror symmetry
%    obj = closed( obj, { i1, p1, p2, ... } )  
%            closed surface of particle i1 togerger with the equaivalent
%            particle and particles p1, p2, ...  

%  index to equivalent particle surfaces
ind = reshape( ( 1 : length( obj.pfull.p ) )', [], size( obj.symtable, 2 ) );

for i = 1 : length( varargin )
  
  %  input is index to particle(s) stored in pfull
  if ~iscell( varargin{ i } )
    fun = @( i )  ...
      ( repmat( sign( i( : ) ), 1, size( ind, 2 ) ) .* ind( abs( i ), : ) );
    %  table of equivalent particles
    tab = reshape( fun( varargin{ i } ), 1, [] );
    for j = tab
      obj.pfull.closed{ abs( j ) } = tab;
    end
    
  %  input is an additional particle
  else
    %  table of equivalent particles
    tab = reshape( ind( varargin{ i }{ 1 }, : ), 1, [] );
    %  closed particle
    p = vertcat( obj.pfull{ tab }, varargin{ i }{ 2 : end } );
    %  add closed particle to equivalent particles
    for j = 1 : length( tab )
      obj.pfull.closed{ j } = p;
    end
  end
  
end
