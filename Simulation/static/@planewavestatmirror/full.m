function [ val, p ] = full( obj, val )
%  FULL - Surface charge, potentials and electric field for full particle.
%
%  Usage for obj = planewavestatmirror :
%    [ val, p ] = full( obj, val )
%  Input
%    val    :  COMPSTRUCTMIRROR object containing surface charge or electric field
%  Output
%    val    :  values expanded for full particle
%    p      :  expanded COMPARTICLE object

%  polarizations
pol = obj.exc.pol;

%  expand input
[ val1, val2 ] = expand( val );
%  expanded particle
p = val1.p;
%  return structure
val = compstruct( p, val1.enei );

%  transform scalars
for name = { 'sig', 'phi', 'phip' }
  if isfield( val1, name )
    
    v1 = val1.( name{ 1 } );
    v2 = val2.( name{ 1 } );
    %  output field for requested polarizations
    v = zeros( size( v1, 1 ), size( pol, 1 ) );
  
    for i = 1 : size( pol, 1 )
      v( :, i ) = ( pol( i, : ) * [ 1, 0, 0 ]' ) * v1 +  ...
                  ( pol( i, : ) * [ 0, 1, 0 ]' ) * v2;
    end
  
    %  assign output
    val.( name{ 1 } ) = v;
  end
end

%  transform vectors
for name = { 'e' }
  if isfield( val1, name{ 1 } )
    
    v1 = val1.( name{ 1 } );
    v2 = val2.( name{ 1 } );
    %  output field for requested polarizations
    v = zeros( size( v1, 1 ), 3, size( pol, 1 ) );
  
    for i = 1 : size( pol, 1 )
      v( :, :, i ) = ( pol( i, : ) * [ 1, 0, 0 ]' ) * v1 +  ...
                     ( pol( i, : ) * [ 0, 1, 0 ]' ) * v2;
    end
  
    %  assig output
    val.( name{ 1 } ) = v;
  end
end
