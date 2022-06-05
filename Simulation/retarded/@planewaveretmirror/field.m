function exc = field( obj, p, enei, inout )
%  Electric and magnetic field for plane wave excitation.
%
%  Usage for obj = planewaveretmirror :
%    exc = field( obj, p, enei, inout )
%  Input
%    p          :  points or particle surface where fields are computed
%    enei       :  light wavelength in vacuum
%    inout      :  compute fields at inner (inout = 1, default) or
%                  outer (inout = 2) surface
%  Output
%    exc        :  compstruct object which contains the electric and 
%                  magnetic fields

if ~exist( 'inout', 'var' );  inout = 1;  end

exc = field(  ...
  planewaveret( obj.pol, obj.dir ), p, enei, inout );