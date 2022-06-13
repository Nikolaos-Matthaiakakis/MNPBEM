function [ sca, dsca ] = scattering( field, medium )
%  SCATTERING - Radiated power for electromagnetic fields.
%
%  Usage  :
%    [ sca, dsca ] = scattering( field )
%  Input
%    field      :  compstruct object with scattered electromagnetic fields
%    medium     :  compute total radiated pwoer only in given medium
%  Output
%    sca        :  total radiated power
%    dsca       :  differential radiated power for particle surface
%                  given in FIELD

%  particle surface for fields at 'infinity'
pinfty = field.p;
%  scattered electric and magnetic fields
e = field.e; 
h = field.h; 
%  Poynting vector in direction of outer surface normal
dsca = 0.5 * real( inner( pinfty.nvec, cross( e, conj( h ), 2 ) ) );
  
%  area of boundary elements
area = pinfty.area;
%  total cross section only in given medium
if exist( 'medium', 'var' ) && ~isempty( medium )
  area( pinfty.expand( num2cell( pinfty.inout( :, end ) ) ) == medium ) = 0;
end
%  total radiated power
sca = squeeze( matmul( reshape( area, 1, [] ), dsca ) );
%  convert differential radiated power to compstruct object
dsca = compstruct( pinfty, field.enei, 'dsca', dsca );
