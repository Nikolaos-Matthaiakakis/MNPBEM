function varargout = field( obj, varargin )
%  FIELD - Compute electromagnetic fields.
%
%  Usage for obj = meshfield :
%    [ e, h ] = field( obj, sig, varargin )
%  Input
%    sig        :  surface charges and currents
%                    or COMPSTRUCT object with electromagnetic fields
%    varargin   :  additional parameters to be passed to Green function
%  Output
%    e          :  electric field
%    h          :  magnetic field, [] for quasistatic simulations

if isempty( obj.nmax )
  [ varargout{ 1 : nargout } ] = field1( obj, varargin{ : } );
else
  [ varargout{ 1 : nargout } ] = field2( obj, varargin{ : } );
end
