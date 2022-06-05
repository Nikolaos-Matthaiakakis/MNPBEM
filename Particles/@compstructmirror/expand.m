function varargout = expand( obj )
%  EXPAND - Expand structure to full particle size using mirror symmetry.
%
%  Usage for obj = compstructmirror :
%    [ val1, val2 ] = expand( obj )
%  Output
%    val      :  COMPSTRUCT objects for full particle

%  get field names
names = fieldnames( obj.val{ 1 } );
%  remove symmetry value
names = names( ~strcmp( 'symval', names ) );

%  return value
[ varargout{ 1 : nargout } ] = deal( compstruct( full( obj.p ), obj.enei ) );

for i = 1 : nargout
for j = 1 : length( names )
  
  %  value
  [ val1, val2 ] = deal( obj.val{ i }.( names{ j } ) );
  %  symmetry value
  symval = obj.val{ i }.symval;
  
  %  determine whether field is a scalar or a vector
  switch names{ j }
    %  scalar
    case { 'phi', 'phip', 'phi1', 'phi2', 'phi1p', 'phi2p', 'sig', 'sig1', 'sig2' }
      for k = 2 : size( symval, 2 )
        %  multiply with symmetry values
        val2 = cat( 1, val2, symval( end, k ) * val1 );
      end
      
    % vector
    case { 'a1', 'a1p', 'a2', 'a2p', 'e', 'h', 'h1', 'h2' }
      for k = 2 : size( symval, 2 )
        %  make copy of VAL
        val3 = val1;
        %  multiply with symmetry values
        for l = 1 : 3
          val3( :, l, : ) = symval( l, k ) * val1( :, l, : );
        end
        val2 = cat( 1, val2, val3 );
      end
    otherwise
      error( 'field name %s not known !\n', names{ i } );
  end
  
  %  add expanded field to structure for full particle
  varargout{ i }.( names{ j } ) = val2;
end
end
