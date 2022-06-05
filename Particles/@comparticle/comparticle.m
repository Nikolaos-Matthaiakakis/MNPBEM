classdef comparticle < compound
  %  Compound of particles in a dielectric environment.
  
  %%  Properties
  properties
    closed      %  index to particles that form a closed surface
  end

  %%  Methods
  methods
    function obj = comparticle( eps, p, inout, varargin )
      %  Set properties of comparticle.
      %
      %  Usage :
      %    obj = comparticle( eps, p, inout, varargin )
      %  Input
      %    eps      :  cell array of dielectric functions
      %    p        :  cell array of n particles
      %    inout    :  index to medium eps
      %    varargin :  options and arguments passed to closed
      
      %  extract options for particles and get closed arguments
      [ p, close ] = getinput( p, varargin{ : } );
      %  initialize compound object
      obj = obj@compound( eps, p, inout );
      %  handle closed arguments
      obj = init( obj, close{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'comparticle :' );
      disp( struct( 'eps', { obj.eps }, 'p', { obj.p( obj.mask ) }, ...
           'inout', obj.inout( obj.mask, : ), 'mask', obj.mask,     ...
                              'closed', { obj.closed( obj.mask ) } ) );
    end
    
    function obj = norm( obj )
      %  Auxiliary information for discretized particle surface.
      obj.pc = vertcat( obj.p{ : } );      
    end
    
  %%  Methods of the particle class

    function obj = clean( obj, varargin )
      %  CLEAN - Apply particle/clean to all particles.
      obj = compfun( obj, @( p ) ( clean( p, varargin{ : } ) ) );
    end
    
    function obj = flip( obj, varargin )
      %  FLIP - Apply particle/flip to all particles.
      obj = compfun( obj, @( p ) ( flip( p, varargin{ : } ) ) );
    end
    
    function obj = flipfaces( obj, varargin )
      %  FLIPFACES - Apply particle/flipfaces to all particles.
      obj = compfun( obj, @( p ) ( flipfaces( p, varargin{ : } ) ) );
    end
    
    function obj = rot( obj, varargin )
      %  ROT- Apply particle/rot to all particles.
      obj = compfun( obj, @( p ) ( rot( p, varargin{ : } ) ) );
    end
    
    function obj = scale( obj, varargin )
      %  SCLAE - Apply particle/scale to all particles.
      obj = compfun( obj, @( p ) ( scale( p, varargin{ : } ) ) );
    end
    
    function obj = shift( obj, varargin )
      %  SHIFT - Apply particle/shift to all particles.
      obj = compfun( obj, @( p ) ( shift( p, varargin{ : } ) ) );
    end
    
    function curv = curvature( obj, varargin )
      %  CURVATURE - Curvature of particle.
      curv = curvature( obj.pc, varargin{ : } );
    end  
    
    function varargout = quad( obj, varargin )
      %  QUAD - Integration over boundary elements.
      [ varargout{ 1 : nargout } ] = quad( obj.pc, varargin{ : } );
    end

    function varargout = quadpol( obj, varargin )
      %  QUADPOL - Integration over boundary elements using polar coordinates.
      [ varargout{ 1 : nargout } ] = quadpol( obj.pc, varargin{ : } );
    end    
    
  end
  
  %% Privat methods
  methods (Access = private )
    
    function obj = compfun( obj, fun )
      %  COMPFUN - Apply function to all particles of object.
      for i = 1 : length( obj.p );  obj.p{ i } = fun( obj.p{ i } );  end
      %  auxiliary information
      obj = norm( obj );
    end

  end
  
end
