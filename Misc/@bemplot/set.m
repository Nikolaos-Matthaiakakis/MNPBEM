function [] = set( varargin )
%  SET - Set properties of BEMPLOT object.
%
%  Usage :
%    set(    PropertyPairs )
%    set( h, PropertyPairs )
%  Input
%    h      :  graphics handle, gcf on default
%  PropertyPairs
%    ind    :  index for paging plots
%    fun    :  plot function ('real', 'imag', 'abs', or user-defined)
%    scale  :  scale factor for vector function
%    sfun   :  scale function for vector functions

%  deal with different calling sequences
if ~ischar( varargin{ 1 } )
  [ h, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  h = gcf;
end

%  get BEMPLOT object
obj = get( h, 'UserData' );
%  extract input
op = getbemoptions( varargin{ : } );

%  index
if isfield( op, 'ind' )
  %  multidimensional index ?
  if ~isscalar( op.ind )
    op.ind = num2cell( op.ind );
    op.ind = sub2ind( obj.siz, op.ind{ : } );  
  end
  %  save index
  obj.opt.ind  = op.ind;
end
%  set plot options
if isfield( op, 'fun' ),    obj.opt.fun   = op.fun;    end
if isfield( op, 'scale' ),  obj.opt.scale = op.scale;  end
if isfield( op, 'sfun' ),   obj.opt.sfun  = op.sfun;   end

try
  %  replot value and vector arrays that are affected
  obj = refresh( obj, varargin{ 1 : 2 : end } );
  %  save object to figure
  set( h, 'UserData', obj );
catch err
  %  input provided by user has caused error
  errordlg( 'Error in plot options, no update of figure' );
  %  throw error
  throw( err );
end
