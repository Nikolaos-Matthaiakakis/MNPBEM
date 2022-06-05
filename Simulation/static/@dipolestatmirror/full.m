function [ val, p ] = full( obj, val )
%  Surface charge, potentials and electric field for full particle.
%
%  Usage for obj = dipolestatmirror :
%    [ val, p ] = full( obj, val )
%  Input
%    val    :  COMPSTRUCTMIRROR object containing surface charge or electric field
%  Output
%    val    :  values expanded for full particle
%    p      :  expanded COMPARTICLE object

%  expand value array
switch val.p.sym
  case { 'x', 'y' }
    [ val1, val2 ] = expand( val );   
    vmean = 0.50 * ( val1 + val2 );
  case 'xy'
    [ val1, val2, val3, val4 ] = expand( val );     
    vmean = 0.25 * ( val1 + val2 + val3 + val4 );
end

%  expanded particle
p = val1.p;
%  return structure
val = compstruct( p, val1.enei );

%  requested dipole moments
dip = obj.dip.dip;
%  inner product
inner = @( u, v ) ( squeeze( u ) * v' );

%  transform scalars
for name = { 'sig', 'phi1', 'phi1p', 'phi2', 'phi2p' }
  if isfield( vmean, name )
    
    v = vmean.( name{ 1 } );
    %  interpolated field for different dipole momets
    vi = zeros( size( v, 1 ), size( dip, 1 ), size( dip, 3 ) );
  
    for i = 1 : size( dip, 1 )
    for j = 1 : size( dip, 3 )
      vi( :, i, j ) =  ...
        inner( dip( i, :, j ), [ 1, 0, 0 ] ) * v( :, i, 1 ) +  ...
        inner( dip( i, :, j ), [ 0, 1, 0 ] ) * v( :, i, 2 ) +  ...
        inner( dip( i, :, j ), [ 0, 0, 1 ] ) * v( :, i, 3 );
    end
    end
  
    %  assign output
    val.( name{ 1 } ) = vi;
  end
end

%  transform vectors
for name = { 'e' }
  if isfield( vmean, name )
    
    v = vmean.( name{ 1 } );
    %  interpolated field for different dipole momets
    vi = zeros( size( v, 1 ), 3, size( dip, 1 ), size( dip, 3 ) );
  
    for i = 1 : size( dip, 1 )
    for j = 1 : size( dip, 3 )
      vi( :, :, i, j ) =  ...
        inner( dip( i, :, j ), [ 1, 0, 0 ] ) * v( :, :, i, 1 ) +  ...
        inner( dip( i, :, j ), [ 0, 1, 0 ] ) * v( :, :, i, 2 ) +  ...
        inner( dip( i, :, j ), [ 0, 0, 1 ] ) * v( :, :, i, 3 );
    end
    end
  
    %  assign output
    val.( name{ 1 } ) = vi;
  end
end
