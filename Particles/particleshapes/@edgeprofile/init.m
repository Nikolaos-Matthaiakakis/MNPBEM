function obj = init( obj, varargin )
%  INIT - Initialize edge profile.
%
%  Usage for obj = edgeprofile :
%    obj = init( obj )
%    obj = init( edgeprofile, height,     PropertyPair )
%    obj = init( edgeprofile, height, nz, PropertyPair )
%    obj = init( edgeprofile, pos,     z, PropertyPair )
% Input
%    height   :  height of particle
%    nz       :  number of z-values
%    pos      :  (z,d) values for edge profile
%    z        :  z-values for extruding polygon
%  PropertyName
%    'e'      :  exponent of supercircle
%    'dz'     :  z in [ - height + dz, height - dz ] / 2 for d >= 0
%    'min'    :  minimal z-value of edge profile
%    'max'    :  maximal z-value of edge profile
%    'center' :  central z-value of edge profile
%    'mode'   :  '00', '10', '01', '11', '20', '02' with
%                rounded (0), no (1) and partially rounded (2) edge

%  empty edge profile
if isempty( varargin ),  return;  end

%  explicit constructor with POS and Z
if numel( varargin{ 1 } ) ~= 1
  [ obj.pos, obj.z, op ] =  ...
    deal( varargin{ 1 }, varargin{ 2 }, getbemoptions( varargin{ 3 : end } ) );
else
  if numel( varargin ) == 1 || ~isnumeric( varargin{ 2 } )
    %  extract height
    [ height, op ] =  ...
      deal( varargin{ 1 }, getbemoptions( varargin{ 2 : end } ) );
    %  default value for NZ
    nz = 7;
  else
    %  extract height and NZ
    [ height, nz, op ] =  ...
    deal( varargin{ 1 }, varargin{ 2 }, getbemoptions( varargin{ 3 : end } ) );
  end
  
  %  default value for mode
  if ~isfield( op, 'mode' ),  op.mode = '00';  end
  
  if strcmp( op.mode, '11' )
    %  edge profile
    obj.pos = [ NaN, 0; 0, - 0.5 * height; 0, 0.5 * height; NaN, 0 ];
    %  representative z-values
    obj.z = linspace( - 0.5, 0.5, nz ) * height;
  else
    %  exponent of supercircle
    e  = 0.4;   if isfield( op, 'e'  ),  e = op.e;    end
    %  z in [ - height + dz, height - dz ] / 2 for d >= 0  
    dz = 0.15;  if isfield( op, 'dz' ),  dz = op.dz;  end
   
    %  supercircle
    pows =  @( z ) ( sign( z ) .* abs( z ) .^ e );
    %  angles
    phi = reshape( pi / 2 * linspace( - 1, 1, 51 ), [], 1 );

    x = pows( cos( phi ) );
    z = pows( sin( phi ) );

    [ ~, ind ] = min( abs( z - ( 1 - dz ) ) );

    %  make edge profile
    obj.pos = 0.5 * height * [ x - x( ind ), z ];
    %  representative values along z 
    z = linspace( - 1, 1, nz );
    obj.z = obj.pos( ind, 2 ) * abs( z ) .^ e .* sign( z );
  
    %  indices
    ind2 = obj.pos( :, 2 ) >  0  &  obj.pos( :, 1 ) >= 0;
    ind3 = obj.pos( :, 2 ) == 0;
    ind4 = obj.pos( :, 2 ) <  0  &  obj.pos( :, 1 ) >= 0;
    ind5 = obj.pos( :, 2 ) <  0  &  obj.pos( :, 1 ) <  0;
      
    %  sharp upper edge
    if op.mode( 1 ) ~= '0'
      %  shift value
      dz = 0.5 * height - max( obj.pos( ind2, 2 ) );
      %  modify d-value for upper positions
      if op.mode( 1 ) == '1' 
        obj.pos( ind2, 1 ) = max( obj.pos( ind2, 1 ) );
      end
      %  modify z-value for upper positions
      obj.pos( ind2, 2 ) = obj.pos( ind2, 2 ) + dz;
      %  keep selected positions and z-values
      obj.pos = [ obj.pos( ind2 | ind3 | ind4 | ind5, : ); NaN, 0 ];
      obj.z( obj.z > 0 ) = obj.z( obj.z > 0 ) + dz;
    end
    
    %  indices
    ind1 = obj.pos( :, 2 ) >  0  &  obj.pos( :, 1 ) <  0;
    ind2 = obj.pos( :, 2 ) >  0  &  obj.pos( :, 1 ) >= 0;
    ind3 = obj.pos( :, 2 ) == 0;
    ind4 = obj.pos( :, 2 ) <  0  &  obj.pos( :, 1 ) >= 0;
    
    %  sharp lower edge      
    if op.mode( 2 ) ~= '0'
      %  shift value
      dz = 0.5 * height + min( obj.pos( ind4, 2 ) );
      %  modify d-value for lower positions
      if op.mode( 2 ) == '1'        
        obj.pos( ind4, 1 ) = max( obj.pos( ind4, 1 ) );
      end
      %  modify z-value for lower positions
      obj.pos( ind4, 2 ) = obj.pos( ind4, 2 ) - dz;
      %  keep selected positions and z-values
      obj.pos = [ NaN, 0; obj.pos( ind1 | ind2 | ind3 | ind4, : ) ];
      obj.z( obj.z < 0 ) = obj.z( obj.z < 0 ) - dz;        
    end
  end
end


%  handle shift arguments
if isfield( op, 'max' )
  dz = op.max - max( obj.pos( :, 2 ) );
elseif isfield( op, 'min' )
  dz = op.min - min( obj.pos( :, 2 ) );
elseif isfield( op, 'center' )
  dz = op.center;
else
  dz = 0;
end

%  shift positions and z-values
[ obj.pos( :, 2 ), obj.z ] = deal( obj.pos( :, 2 ) + dz, obj.z + dz );
