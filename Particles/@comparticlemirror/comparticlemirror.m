classdef comparticlemirror < bembase & comparticle 
  %  Compound of particles with mirror symmetry in a dielectric environment.
  
  %%  Properties
  properties (Constant)
    name = 'bemparticle'
    needs = { 'sym' }
  end  
  
  properties
    sym         %  symmetry key
    symtable    %  table with symmetry values
    pfull       %  full comparticle produced with mirror symmetry
  end
  
  %%  Methods
  methods
    function obj = comparticlemirror( eps, p, inout, varargin )
      %  Set properties of comparticle with mirror symmetry.
      %
      %  Usage :
      %    obj = comparticlemirror( eps, p, inout,         op, PropertyPair )
      %    obj = comparticlemirror( eps, p, inout,             PropertyPair )      
      %    obj = comparticlemirror( eps, p, inout, closed, op, PropertyPair )
      %    obj = comparticlemirror( eps, p, inout, closed,     PropertyPair )
      %  Input
      %    eps           :  cell array of dielectric functions
      %    p             :  cell array of n particles
      %    inout         :  index to medium EPS
      %    closed        :  arguments passed to CLOSED
      %    op            :  options
      %    PropertyPair  :  additional property names and values
      %                       OP or PropertyName must contain a field SYM
      %                       set to the symmetry keys 'x', 'y', or 'xy'
      %                       which determines the chosen mirror symmetry
      
      %  initialize COMPARTICLE object w/o closed argument
      op = varargin;  
      if ~isempty( op ) && isnumeric( op{ 1 } ),  op = op( 2 : end );  end
      %  initialization
      obj = obj@comparticle( eps, p, inout, op{ : } );
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'comparticlemirror :' );
      disp( struct( 'eps', { obj.eps }, 'p', { obj.p },        ...
        'inout', obj.inout, 'sym', obj.sym, 'mask', obj.mask ) );
    end
          
    function p = full( obj )
      %  FULL - Full particle produced with mirror symmetry.
      %
      %  Usage for obj = comparticlemirror :
      %    p = full( obj )
      %  Output
      %    p        :  comparticle object of full particle
      p = obj.pfull;
    end

    function [ p, dir, loc ] = closedparticle( obj, ind )
      %  Return particle with closed surface for particle ind.
      %
      %  Usage for obj = comparticlemirror :
      %    [ p, dir ] = closedparticle( obj, ind )
      %  Input
      %    obj        :  compound of particles
      %    ind        :  index to given particle
      %  Output
      %    p          :  closed particle ([] if not closed)
      %    dir        :  outer (dir=1) or inner (dir=-1) surface normal
      [ p, dir ] = closedparticle@comparticle( obj.pfull, ind );  loc = [];
    end
    
    function ind = symindex( obj, tab )
      %  Index of symmetry values within symmetry table.
      %
      %  Usage for obj = comparticlemirror :
      %    ind = symindex( obj, tab )
      %  Input
      %    tab      :  two or four symmetry values
      %  Output
      %    ind      :  index to symmetry table
      ind = find( all( obj.symtable ==  ...
                       repmat( tab, size( obj.symtable, 1 ), 1 ), 2 ) );
    end
    
  end

  %%  Hidden methods
  methods (Hidden = true)
    varargout = clean( varargin );
  	varargout = flip( varargin );
  	varargout = flipfaces( varargin );
  	varargout = norm( varargin );
  	varargout = rot( varargin );
  	varargout = scale( varargin );
  	varargout = select( varargin );
  	varargout = shift( varargin );
  end
  
  %%  Private methods  
  methods (Access = private)
    obj = init( obj, varargin );
  end
end
