function [ ene, ur, ul ] = plasmonmode( p, nev, varargin )
%  PLASMONMODE - Compute plasmon eigenmodes for discretized surface.
%
%  Usage :
%    [ ene, ur, ul ] = plasmonmode( p, nev, varargin )
%  Input
%    p          :  compound of discsretized particles
%    nev        :  number of eigenmodes
%    varargin   :  additional arguments to be passed to BEMSTATEIG
%  Output
%    ene        :  eigenenergies
%    ur         :  right eigenvectors
%    ul         :  left eigenvectors

if ~exist( 'nev', 'var' );  nev = 20;  end

%  compute plasmon modes
bem = bemstateig( p, varargin{ : }, 'nev', nev );
%  get eigenenergies and eigenmodes
ene = diag( bem.ene );
[ ene, ind ] = sort( real( ene ) );

ur = bem.ur( :, ind );
ul = bem.ul( ind, : );
