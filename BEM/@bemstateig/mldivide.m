function  [ sig, obj ] = mldivide( obj, exc )
%  Surface charge for given excitation.
%
%  Usage for obj = bemstateig :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  compstruct with field 'phip' for external excitation
%  Output
%    sig    :  compstruct with field containing surface charges

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );

sig = compstruct( obj.p, exc.enei, 'sig',  matmul( obj.mat, exc.phip ) );
