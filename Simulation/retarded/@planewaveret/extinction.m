function ext = extinction( obj, sig )
%  EXTINCTION - Extinction cross section for plane wave excitation.
%
%  Usage for obj = planewaveret :
%    abs = extinction( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charge
%  Output
%    ext        :  extinction cross section

%  far-field amplitude
[ field, k ] = farfield( obj.spec, sig, obj.dir );
%  extinction cross section (from optical theorem)
%    note that INNER calls the Matlab DOT function which takes the complex
%    conjugate of the first argument
ext = 4 * pi / k * diag( imag( inner( obj.pol, field.e ) ) ) .';
