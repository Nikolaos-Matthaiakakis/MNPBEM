function exc = field2( obj, p, enei )
%  FIELD1 - Electric field for mirror dipole excitation.
%
%  Usage for obj = dipolestatlayer :
%    exc = field2( obj, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  COMPSTRUCT object which contains the electric field, 
%                  the last two dimensions of exc.e correspond to the 
%                  positions and dipole moments

%  dielectric functions
eps = cellfun( @( eps ) eps( enei ), obj.layer.eps );
%  image charges, see Jackson Eq. (4.45)
q1 = - ( eps( 2 ) - eps( 1 ) ) / ( eps( 2 ) + eps( 1 ) );
q2 =            2 * eps( 2 )   / ( eps( 2 ) + eps( 1 ) );

%  electric field positions only above substrate ?
if all( p.pos( :, 3 ) > obj.layer.z )
  exc = q1 * field( obj.idip, p, enei );
else
  %  index to positions above and below substrate
  ind1 = p.pos( :, 3 ) > obj.layer.z;
  ind2 = p.pos( :, 3 ) < obj.layer.z;
  %  allocate output array
  e = zeros( p.n, 3, obj.dip.pt.n, size( obj.dip.dip, 3 ) );

  if any( ind1 )
    %  fields above substrate
    e1 = q1 * field( obj.idip, struct( 'pos', p.pos( ind1, : ) ), enei );
    %  save fields
    e( ind1, :, :, : ) = e1.e;
  end
  if any( ind2 )
    %  fields below substrate
    e2 = q2 * field( obj. dip, struct( 'pos', p.pos( ind2, : ) ), enei );
    %  save fields
    e( ind2, :, :, : ) = e2.e;
  end

  % save in compstruct
  exc = compstruct( p, enei, 'e', e );
end
  