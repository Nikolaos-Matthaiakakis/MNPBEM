function vec = mfun( obj, vec )
%  MFUN1 - Preconditioner for CGS, BICGSTAB, GMRES.
%
%  For the precoditioner we solve the BEM equations using the approximate
%  H-matrix inverse of the resolvent matrix.

vec = reshape( vec, obj.p.n, [] );
%  preconditioner
switch obj.precond
  case 'hmat'
    vec = solve( obj.mat, vec );
  case 'full'
    vec = obj.mat * vec;
end
%  pack vector
vec = vec( : );
