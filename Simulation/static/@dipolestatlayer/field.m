function exc = field( obj, p, enei, key )
%  FIELD - Electric field for dipole excitation.
%
%  Usage for obj = dipolestatlayer :
%    exc = field( obj, enei )
%    exc = field( obj, enei, 'refl' )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%    'refl'     :  compute only reflected part of electric dipole field
%                  (image dipole)
%  Output
%    exc        :  COMPSTRUCT object which contains the electric field, 
%                  the last two dimensions of exc.e correspond to the 
%                  positions and dipole moments

if exist( 'key', 'var' ) && strcmp( key, 'refl' )
  exc = field2( obj, p, enei );  
else
  %  dielectric functions
  eps = cellfun( @( eps ) eps( enei ), obj.layer.eps );
  %  image charges, see Jackson Eq. (4.45)
  q1 = - ( eps( 2 ) - eps( 1 ) ) / ( eps( 2 ) + eps( 1 ) );
  q2 =            2 * eps( 2 )   / ( eps( 2 ) + eps( 1 ) );

  %  electric field positions only above substrate ?
  if all( p.pos( :, 3 ) > obj.layer.z )
    exc = field( obj.dip, p, enei ) + q1 * field( obj.idip, p, enei );
  else
    %  index to positions above and below substrate
    ind1 = p.pos( :, 3 ) > obj.layer.z;
    ind2 = p.pos( :, 3 ) < obj.layer.z;
    %  allocate output array
    e = zeros( p.n, 3, obj.dip.pt.n, size( obj.dip.dip, 3 ) );

    if any( ind1 )
      %  fields above substrate
      e1 =      field( obj. dip, struct( 'pos', p.pos( ind1, : ) ), enei ) +  ...
           q1 * field( obj.idip, struct( 'pos', p.pos( ind1, : ) ), enei );
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
end
  