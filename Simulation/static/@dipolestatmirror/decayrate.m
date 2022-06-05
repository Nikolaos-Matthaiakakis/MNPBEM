function varargout = decayrate( obj, sig, varargin )
%  Total and radiative decay rate for oscillating dipole
%                       in units of the free-space decay rate.
%
%  Usage for obj = dipolestatmirror :
%    [ nonrad, rad ] = decayrate( obj, sig, op )
%  Input
%    sig        :  compstructmirror object containing surface charge
%    op         :  options for compgreen
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate

[ varargout{ 1 : nargout } ] = decayrate( obj.dip, full( obj, sig ), varargin{ : } );
     