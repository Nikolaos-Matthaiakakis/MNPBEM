function ext = extinction( field, infield )
%  EXTINCTION - Extinction cross section from electromagnetic fields.
%
%  Usage  :
%    ext = extinction( field, infield )
%  Input
%    field      :  compstruct object with scattered electromagnetic fields
%    infield    :  compstruct object with incoming  electromagnetic fields
%  Output
%    ext        :  extinction cross section

%%  extract input
%  particle surface for fields at 'infinity'
pinfty = field.p;
%  scattered electric and magnetic fields
e = field.e;
h = field.h;
%  incoming electric and magnetic fields
ein = infield.e;
hin = infield.h;
%  background dielectric constant
nb = sqrt( pinfty.eps{ pinfty.inout( end ) }( field.enei ) );

%%  extinction cross section
dext = - matmul( 1 ./ nb,  ...
  inner( pinfty.nvec, real( cross( e, conj( hin ), 2 ) +  ...
                            cross( conj( ein ), h, 2 ) ) ) );
%  total cross section
ext = squeeze( matmul( pinfty.area', dext ) );
