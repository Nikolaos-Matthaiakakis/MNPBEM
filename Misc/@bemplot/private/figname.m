function [] = figname( obj, h )
%  FIGNAME - Set name of figure.
%
%  Usage for obj = bemplot :
%    figname( obj, h )
%  Input
%    h      :  figure handle

%  get figure handle
if ~exist( 'h', 'var' ),  h = gcf;  end

switch func2str( obj.opt.fun )
  case '@(x)real(x)'
    name = '(real)';
  case '@(x)imag(x)'
    name = '(imag)';
  case '@(x)abs(x)'
    name = '(abs)';
  otherwise
    name = '(fun)';
end

if ~isempty( obj.siz )
  %  index
  [ ind{ 1 : numel( obj.siz ) } ] = ind2sub( obj.siz, obj.opt.ind );
  %  add to string
  name = [ 'Element ', mat2str( [ ind{ : } ] ),  ...
               ' of ', mat2str( obj.siz ), '  ', name ];
end
  
%  set figure name
set( h, 'Name', name );
