%% Dielectric materials
%
% The MNPBEM toolbox provides three classes |epsconst|, |epsdrude|, and
% |epstable| for the definition of dielectric functions.
%
%% Initialization

%  constant dielectric function
eps = epsconst( 2.25 );
%  Drude dielectric function, works for 'Au', 'Ag', 'Al'
eps = epsdrude( 'Au' );   
%  tabulated dielectric function
eps = epstable( 'gold.dat' );

%%
% * *|epsconst|* defines a constant dielectric function.
% * *|epsdrude|* defines a Drude dielectric function.  Details of the Drude
% parameters can be found in the |epsdrude| <matlab:doc('epsdrude') class
% definition>.  In general, the Drude dielectric function is a good
% approximation for _Al_ and _Ag_ throughout the whole frequency range.
% For _Au_ the photon energy should not exceed 2 eV where _d_-band
% transitions set in.
% * *|epstable|* loads a dielectric function whose values are tabulated on
% a file for specific photon energies, and performs a spline interpolation.
% The following files are available:
%
%    'gold.dat'          
%    'silver.dat'           P. B. Johnson and R. W. Christy, PRB 6, 4370 (1972).
%    'goldpalik.dat'        E. Palik and G. Ghosh, 
%    'silverpalik.dat'        Handbook of Optical Constants
%    'copperpalik.dat'        of Solids II (Academic Press, New York, 1991).
%
% If you want to supply your own data files, they must be in ASCII format
% and must contain three columns of the form
%
%    ene  n  k
%
% where |ene| is the photon energy in eV, and |n| and |k| are the real and
% imaginary parts of the refractive index, respectively.  For an example
% see <matlab:edit('gold.dat') gold.dat>.
%
%% Methods for the dielectric classes
%
% The dielectric classes have a |subsref| implementation that allows to
% evaluate them through

%  evaluation of dielectric function at wavelength ENEI
[ eps, k ] = epsobj( enei );
%%
% |enei| is the light wavelength in vacuum given in nanometers.  The output
% consists of the dielectric function |eps| at the requested frequency and
% the corresponding wavenumber |k| in the medium.  These dielectric classes
% are the only ones of the MNPBEM toolbox that request |enei| to be in
% nanometers.
%
% Evaluating the dielectric function for energies in electron volt raher
% than nanometers can be done as follows:

%  load conversion factor beteen eV and nm
units;
%  energy in eV
ene = 2;
%  convert energy to wavelength
enei = eV2nm ./ ene;

%% User-defined dielectric classes
%
% If you want to write your own class or function for dielectric materials,
% it must consist of an
%
% * initialization (constructor) for the dielectric function, and a
% * |[ eps, k ] = epsobj( enei )| function call.
%
% Alternatively you can also set up a dielectric function using the
% |epsfun| class.  For instance, a Drude-type dielectric function
% representative for gold is implemented through

%  set up Drude-type dielectric function representative for Au
epsobj = epsfun( @( w ) 1 - 3.3 ^ 2 ./ ( w .* ( w + 0.165i ) ), 'eV' );
%  evaluate dielectric function for given wavelength ENEI
[ eps, k ] = epsobj( enei );

%%
% The key |'eV'| indicates that the dielectric function is evaluated in
% electron Volts.  Alternatively, one could use |'nm'| to indicate that the
% dielecric function is evaluated for wavelengths given in nanometers.
%
% Copyright 2017 Ulrich Hohenester