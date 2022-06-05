function [ sig, obj ] = mldivide( obj, exc )
%  Surface charge for given excitation.
%
%  Usage for obj = bemstatmirror :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  COMPSTRUCTMIRROR object with field 'phip' for external excitation
%  Output
%    sig    :  COMPSTRUCTMIRROR object with field for surface charge

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );
%  initialize surface charges
sig = compstructmirror( obj.p, exc.enei, exc.fun );

%  loop over excitations
for i = 1 : length( exc.val )
  %  get symmetry value
  ind = obj.p.symindex( exc.val{ i }.symval( end, : ) );
  %  surface charge
  sig.val{ i } = compstruct( obj.p, exc.enei, 'sig',  ...
                             matmul( obj.mat{ ind }, exc.val{ i }.phip ) );
  %  set symmetry value
  sig.val{ i }.symval = exc.val{ i }.symval;
end
