function exc = field( obj, p, enei )
%  FIELD - Electric field for plane wave excitation and layer structure.
%
%  Usage for obj = planewavestatlayer :
%    exc = field( obj, p, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct object for electric field

%  wavenmumber of light
k0 = 2 * pi / enei;

%  polarization and light propagation direction
[ pol, dir ] = deal( obj.pol, obj.dir );
%  allocate array for field
e = zeros( p.n, 3, size( dir, 1 ) );
%  index to points above and below layer
ind1 = find( p.pos( :, 3 ) >= obj.layer.z );
ind2 = find( p.pos( :, 3 ) <  obj.layer.z );

%  decompose electric fields of waves
[ te, tm ] = decompose( obj );
%  compute reflection and transmission coefficients
refl = fresnel( obj, enei );
%  magnetic field of TM mode
tm = cross( refl.ki, tm, 2 ) / k0;
%  electric field for reflected or transmitted TM mode
er = @( i ) cross( tm( i, : ), refl.kr( i, : ), 2 ) * k0 / sum( refl.kr( i, : ) .^ 2 );
et = @( i ) cross( tm( i, : ), refl.kt( i, : ), 2 ) * k0 / sum( refl.kt( i, : ) .^ 2 );


%  loop over propagation directions
for i = 1 : size( dir, 1 )
  %  downgoing wave
  if obj.dir( i, 3 ) < 0
    %  fields in upper and lower medium
    e1 = pol( i, : ) + refl.re( i ) * te( i, : ) + refl.rm( i ) * er( i );
    e2 =               refl.te( i ) * te( i, : ) + refl.tm( i ) * et( i );
  %  upgoing wave
  else
    %  fields in upper and lower medium
    e1 =               refl.te( i ) * te( i, : ) + refl.tm( i ) * et( i );
    e2 = pol( i, : ) + refl.re( i ) * te( i, : ) + refl.rm( i ) * er( i );
  end
  %  expand to particle size
  if ~isempty( ind1 ),  e( ind1, :, i ) = repmat( e1, size( ind1, 1 ), 1 );  end
  if ~isempty( ind2 ),  e( ind2, :, i ) = repmat( e2, size( ind2, 1 ), 1 );  end  
end

%  save electric field in COMPSTRUCT object
exc = compstruct( p, enei, 'e', squeeze( e ) );
