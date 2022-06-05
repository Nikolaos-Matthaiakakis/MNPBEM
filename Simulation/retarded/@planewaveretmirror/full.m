function [ val, p ] = full( obj, val )
%  Surface charges and currents, potentials & em fields for full particle.
%
%  Usage for obj = planewaveretmirror :
%    [ val, p ] = full( obj, val )
%  Input
%    val    :  compstructmirror object containing surface charges and
%               currents, potentials, or electromagnetic fields
%  Output
%    val    :  values expanded for full particle
%    p      :  expanded COMPARTICLE objectt

%  polarizations and light propagation directions
pol = obj.pol;
dir = obj.dir;

%  expand input
[ val1, val2 ] = expand( val );
%  expanded particle
p = val1.p;
%  return structure
val = compstruct( p, val1.enei );

%  transform scalars
for name = { 'sig1', 'sig2', 'phi1', 'phi1p', 'phi2', 'phi2p' }
  if isfield( val1, name )
    
    v1 = val1.( name{ 1 } );
    v2 = val2.( name{ 1 } );
    %  output field for requested polarizations
    v = zeros( size( v1, 1 ), size( pol, 1 ) );
    
    for i = 1 : size( pol, 1 )
      %  index for light propagation direction
      if dir( i, 3 ) > 0;
        j = 1;
      else
        j = 2;  
      end
      v( :, i ) = ( pol( i, : ) * [ 1, 0, 0 ]' ) * v1( :, j ) +  ...
                  ( pol( i, : ) * [ 0, 1, 0 ]' ) * v2( :, j );
    end
    
    %  assign output
    val.( name{ 1 } ) = v;
    
  end
end

%  transform vectors
for name = { 'h1', 'h2', 'a1', 'a1p', 'a2', 'a2p', 'e', 'h' }
  if isfield( val1, name )
    
    v1 = val1.( name{ 1 } );
    v2 = val2.( name{ 1 } );
    %  output field for requested polarizations
    v = zeros( size( v1, 1 ), 3, size( pol, 1 ) );
    
    for i = 1 : size( pol, 1 )
      %  index for light propagation direction
      if dir( i, 3 ) > 0;
        j = 1;
      else
        j = 2;  
      end
      v( :, :, i ) = ( pol( i, : ) * [ 1, 0, 0 ]' ) * v1( :, :, j ) +  ...
                     ( pol( i, : ) * [ 0, 1, 0 ]' ) * v2( :, :, j );
    end
    
    %  assig output
    val.( name{ 1 } ) = v;
    
  end
end
