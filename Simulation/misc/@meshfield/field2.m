function [ e, h ] = field2( obj, sig, varargin )
%  FIELD - Compute electromagnetic fields in portions.
%
%  Usage for obj = meshfield :
%    [ e, h ] = field2( obj, sig, varargin )
%  Input
%    sig        :  surface charges and currents
%                    or COMPSTRUCT object with electromagnetic fields
%    varargin   :  additional parameters to be passed to Green function
%  Output
%    e          :  electric field
%    h          :  magnetic field, [] for quasistatic simulations

if isfield( sig, 'e' )
  %  SIG is treated as field array;
  f = sig;
else
  %  option structure
  op = obj.op;
  %  waitbar
  if ~isfield( op, 'waitbar' ),  op.waitbar = false;  end
  %  initialize waitbar
  if op.waitbar,  multiWaitbar( 'Evaluating meshfield', 0, 'CanCancel', 'on' );  end
  %  portions to NMAX
  is = 0 : min( obj.nmax, obj.pt.n ) : obj.pt.n;
  %  add final element
  if is( end ) ~= obj.pt.n,  is = [ is, obj.pt.n ];  end
  
  %  work off calculation in portions of NMAX
  for i = 2 : numel( is ) 
    
    %  slice indices
    ind = ( is( i - 1 ) + 1 ) : is( i ); 
    %  select point
    pt = select( obj.pt, 'index', ind );
    %  set up Green function
    g = greenfunction( pt, obj.p, obj.op, 'waitbar', 0 );
    %  compute field
    f = field( g, sig, varargin{ : } );
    
    %  allocate field
    if ~exist( 'e', 'var' )
      %  size of electric field
      siz = size( f.e );  siz( 1 ) = obj.pt.n;
      %  allocate electric field
      e = zeros( siz );  e( ind, : ) = f.e( :, : );  e = reshape( e, siz );
      %  allocate magnetic field
      if isfield( f, 'h' )
        h = zeros( siz );  h( ind, : ) = f.h( :, : );  h = reshape( h, siz );
      end
    else
      %  save electric field
      e( ind, : ) = f.e( :, : );  e = reshape( e, siz );
      %  save magnetic field
      if isfield( f, 'h' )
        h( ind, : ) = f.h( :, : );  h = reshape( h, siz );
      end
    end
    
    %  update waitbar
    if op.waitbar
      if multiWaitbar( 'Evaluating meshfield', ( i - 1 ) / ( numel( is ) - 1 ) )
        multiWaitbar( 'CloseAll' );  
        error( 'Evaluation of meshfield stopped' );
      end
    end
  end
  
  %  close waitbar
  if op.waitbar
    multiWaitbar( 'Evaluating meshfield', 'Close' );  
    drawnow;  
  end
  %  save output in field
  f.e = e;  if exist( 'h', 'var' ),  f.h = h;  end
end  
  
%  size of electric field
siz = size( f.e );  
if size( obj.x, 2 ) == 1
  siz = [ size( obj.x, 1 ), siz( 2 : end ) ];
else
  siz = [ size( obj.x    ), siz( 2 : end ) ];
end
%  reshape electric field
e = reshape( obj.pt( f.e ), siz );

if ~isfield( f, 'h' )
  h = [];
else
  h = reshape( obj.pt( f.h ), siz );
end
