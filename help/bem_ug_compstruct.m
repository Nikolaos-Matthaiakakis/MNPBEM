%% The compstruct class
%
% The input and output of the BEM solvers goes via the |compstruct|
% objects.  They are used for the storage of surface charges, potentials,
% and fields.
%
%%  Initialization

%  initialize COMPSTRUCT object
c = compstruct( p, enei );
%  initialization with additional fields
c = compstruct( p, enei, 'field1', field1, 'field2', field2 );

%%
% Compstruct objects behave very much like structures but _must_
% additionally store
%
% * *|p|* a |comparticle| or |compoint| object, and
% * *|enei|* the light wavelength.
%
% Fields can be added to |compstruct| objects either in the initialization
% call or by setting them through

%  add additional fields to COMPSTRUCT object C
c.field1 = field1;
c.field2 = field2;

%% Methods
% The main difference of |compstruct| objects in comparison to normal
% |struct| objects is that one can also treat them as normal arrays.  This
% means, we can add or subtract |compstruct| objects (|c+d|, |c-d|) and we
% can multiply them with a constant value (|h*c|).  In adding or
% subtracting them, fields that are missing in one of the objects are
% treated as zeros.  Upon multiplication all fields of the |compstruct|
% object are multiplied with the same value.  These features are
% particularly useful for |compstruct| object with electromagnetic fields
% that can be easily added or scaled.
%
%% Example
%
% As an example, we investigate the class |planewave| which
% computes for a plane wave illumination the potentials and their surface
% derivatives at the particle boundaries.  For a quasistatic simulation we
% get

%  BEM options for quasistatic simulation
op = bemoptions( 'sim', 'stat' );
%  metallic nanosphere
p = comparticle( { epsconst( 1 ), epstable( 'gold.dat' ) }, { trisphere( 256, 10 ) }, [ 2, 1 ], 1, op );
%  plane wave excitation with polarization along x and light propagation along z
exc = planewave( [ 1, 0, 0 ], [ 0, 0, 1 ], op );
%  evaluate plane wave excitation for wavelength of 500 nm
exc( p, 500 )

%%
%    compstruct : 
%        phip: [508x1 double]
%           p: [1x1 comparticle]
%        enei: 500
%
% In the quasistatic approximation the excitation is described by the
% surface derivative |phip| (which is the same for the inside and outside
% particle boundary).  For the retarded simulation we get 

%  BEM options for solution of full Maxwell equations
op = bemoptions( 'sim', 'ret' );

%%
%    compstruct : 
%          a2: [508x3 double]
%         a2p: [508x3 double]
%           p: [1x1 comparticle]
%        enei: 500
%
% Copyright 2017 Ulrich Hohenester