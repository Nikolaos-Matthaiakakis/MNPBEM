function varargout = decayrate( obj, sig, varargin )
%  Total decay rate for oscillating dipole
%                       in units of the free-space decay rate.
%
%  Usage for obj = dipoleretmirror :
%    tot = decayrate( obj, sig, op )
%  Input
%    sig        :  compstruct object containing surface charges and currents
%    op         :  options for compgreen
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate

[ varargout{ 1 : nargout } ] =  ...
                  decayrate( obj.dip, full( obj, sig ), varargin{ : } );
