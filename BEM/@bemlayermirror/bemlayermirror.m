classdef bemlayermirror < bembase
  %  Dummy class, BEM solvers for layer and mirror symmetry not implemented.
  
  %  Properties 
  properties (Constant)
    name = 'bemsolver'
    needs = { 'sim', 'layer', 'sym' }
  end
  
 
  %  Methods
  methods
    function obj = bemlayermirror( varargin )
      %  Dummy class.
      %    BEM solvers for layers and mirror symmetry are not implemented.
      error( 'BEM solvers for layers and mirror symmetry not implemented' );
    end
  end
    
end
