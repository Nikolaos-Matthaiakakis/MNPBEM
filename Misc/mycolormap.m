function  varargout = mycolormap( key, n )
%  MYCOLORMAP  load colormaps.
%    taken from http://hem.bredband.net/aditus/chunkhtml/ch22s08.html
%
%  INPUT
%    key   ...  'std:1' - 'std:10'  standard maps
%               'cen:1' - 'cen:5'   centered maps
%               'con:1' - 'con:7'   continous maps
%               'demo:std'          show all standard maps
%               'demo:cen'          show all centered maps
%               'demo:con'          show all continous maps
%
%  OUTPUT
%    none  ...  load colormap
%    map   ...  returns map

%  number of colors
if ~exist( 'n', 'var' )
  n = 100;
end


switch key
    
    
  %  standard map 0
  case 'std:1'
    map = [ 0, 0, 0; 69, 0, 0; 139, 0, 0; 197, 82, 0;              ...
            247, 154, 0; 255, 204, 0; 255, 249, 0; 255, 255, 111;  ...
            255, 255, 239 ];     
  %  standard map 1
  case 'std:2'
    map = [ 0, 0, 0; 47, 47, 47; 95, 95, 95; 142, 142, 142;        ...
            184, 184, 184; 204, 204, 204; 220, 220, 220;           ...
            236, 236, 236; 252, 252, 252 ];
  %  standard map 2
  case 'std:3'
    map = [ 139, 0, 0; 255, 0, 0; 255, 165, 0; 255, 255, 0;        ...
            31, 255, 0; 0, 31, 223; 0, 0, 153; 65, 0, 131;         ...
            217, 113, 224 ];      
  %  standard map 3
  case 'std:4'
    map = [ 0, 0, 128; 0, 0, 191; 0, 0, 255; 0, 0, 127; 0, 0, 15;  ...
            111, 0, 0; 239, 0, 0; 204, 0, 0; 146, 0, 0 ];
  %  standard map 4
  case 'std:5'
    map = [ 0, 0, 128; 0, 0, 191; 0, 0, 255; 127, 127, 127;        ...
            239, 239, 15; 255, 143, 0; 255, 15, 0; 204, 0, 0;      ...
            146, 0, 0 ];      
  %  standard map 5
  case 'std:6'
    map = [ 0, 100, 0; 0, 177, 0; 0, 255, 0; 0, 127, 0; 0, 15, 0;  ...
            111, 0, 0; 239, 0, 0; 204, 0, 0; 146, 0, 0 ];      
  %  standard map 6
  case 'std:7'
    map = [ 0, 100, 0; 0, 177, 0; 0, 255, 0; 127, 255, 0;          ...
            239, 255, 0; 255, 143, 0; 255, 15, 0; 204, 0, 0;       ...
            146, 0, 0  ];      
  %  standard map 7
  case 'std:8'
    map = [ 0, 0, 139; 0, 0, 197; 0, 0, 255; 0, 0, 127; 0, 0, 15;  ...
            0, 111, 0; 0, 239, 0; 0, 187, 0; 0, 109, 0 ];      
  %  standard map 8
  case 'std:9'
    map = [ 0, 0, 139; 0, 0, 197; 0, 0, 255; 127, 127, 127;        ...
            239, 239, 15; 143, 255, 0; 15, 255, 0; 0, 187, 0;      ...
            0, 109, 0 ];      
  %  standard map 9
  case 'std:10'
    map = [ 0, 0, 255; 0, 50, 127; 0, 100, 0; 0, 177, 0;           ...
            0, 245, 0; 111, 143, 0; 239, 15, 0; 204, 0, 0;         ...
            146, 0, 0 ];      
  
      
  %  centered map 10
  case 'cen:1'
    map = [ 179, 88, 6; 224, 130, 20; 253, 184, 99; 254, 224, 182;       ...
            247, 247, 247; 219, 221, 236; 182, 176, 213; 134, 122, 176;  ...
            89, 48, 140 ];
  %  centered map 11
  case 'cen:2'
    map = [ 140, 81, 10; 191, 129, 45; 223, 194, 125; 246, 232, 195;     ...
            245, 245, 245; 204, 235, 231; 136, 208, 197; 62, 157, 149;   ...
            7, 108, 100 ];
  %  centered map 12
  case 'cen:3'    
    map = [ 178, 24, 43; 214, 96, 77; 244, 165, 130; 253, 219, 199;      ...
            247, 247, 247; 213, 231, 240; 153, 201, 224; 76, 153, 198;   ...
            37, 107, 174 ];
  %  centered map 13
  case 'cen:4'
    map = [ 178, 24, 43; 214, 96, 77; 244, 165, 130; 253, 219, 199;      ...
            255, 255, 255; 227, 227, 227; 190, 190, 190; 141, 141, 141;  ...
            84, 84, 84 ];
  %  centered map 14
  case 'cen:5'
    map = [ 215, 48, 39; 244, 109, 67; 253, 174, 97; 254, 224, 139;      ...
            255, 255, 223; 221, 241, 149; 172, 219, 110; 110, 192, 99;   ...
            35, 156, 82 ];

        
  %  continous map 15
  case 'con:1'
    map = [ 255, 247, 251; 236, 231, 242; 208, 209, 230; 166, 189, 219;   ...
            122, 171, 208; 61, 147, 193; 11, 116, 178; 4, 92, 145;        ...
            2, 60, 94 ];
  %  continous map 16
  case 'con:2'
    map = [ 247, 252, 253; 229, 245, 249; 204, 236, 230; 153, 216, 201;   ...
            108, 196, 168; 69, 176, 123; 38, 143, 75; 4, 112, 47;         ...
            0, 73, 29 ];
  %  continous map 17
  case 'con:3'
    map =  [ 255, 255, 217; 237, 248, 176; 199, 233, 180; 127, 205, 187;  ...
             72, 184, 194; 33, 149, 192; 33, 100, 171; 36, 57, 150;       ...
             11, 31, 95 ];
  %  continous map 18
  case 'con:4'
    map = [ 255, 247, 236; 254, 232, 200; 253, 212, 158; 253, 187, 132;   ...
            252, 146, 94; 240, 106, 74; 218, 54, 36; 183, 6, 3;           ...
            133, 0, 0 ];
  %  continous map 19
  case 'con:5'
    map = [ 255, 255, 204; 255, 237, 160; 254, 217, 118; 254, 178, 76;    ...
            253, 145, 62; 252, 85, 44; 230, 32, 29; 193, 3, 36;           ...
            177, 0, 38 ];
  %  continous map 20
  case 'con:6'       
    map = [ 255, 255, 229; 255, 247, 188; 254, 227, 145; 254, 196, 79;    ...
            254, 158, 45; 238, 117, 22; 208, 80, 4; 159, 55, 3;           ...
            108, 38, 5 ];
  %  continous map 21
  case 'con:7'
    map = [ 247, 252, 253; 224, 236, 244; 191, 211, 230; 158, 188, 218;   ...
            142, 154, 200; 140, 112, 179; 136, 70, 159; 129, 21, 128;     ...
            83, 1, 81 ];


  %  demo for standard maps
  case 'demo:std'
    
    figure( 'Position', [ 360, 125, 520, 575 ] );
    for i = 1 : 10
      key = sprintf( 'std:%1i', i );
      map = mycolormap( key );
      subplot( 10, 1, i );
      imagesc( reshape( map, [ 1, 100, 3 ] ) );
      set( gca, 'YTickLabel', repmat( ' ', 20 ) );
      title( key );
    end
        
    return        
        
        
  %  demo for centered maps
  case 'demo:cen'
    
    figure( 'Position', [ 360, 125, 520, 575 ] );
    for i = 1 : 5
      key = sprintf( 'cen:%1i', i );
      map = mycolormap( key );
      subplot( 10, 1, i );
      imagesc( reshape( map, [ 1, 100, 3 ] ) );
      set( gca, 'YTickLabel', repmat( ' ', 20 ) );
      title( key );
    end
        
    return
        
  %  demo for continous maps
  case 'demo:con'
    
    figure( 'Position', [ 360, 125, 520, 575 ] );
    for i = 1 : 7
      key = sprintf( 'con:%1i', i );
      map = mycolormap( key );
      subplot( 10, 1, i );
      imagesc( reshape( map, [ 1, 100, 3 ] ) );
      set( gca, 'YTickLabel', repmat( ' ', 20 ) );
      title( key );
    end
        
    return
    
    
  otherwise        
    error( 'map %s not known', key );
    
end


%  interpolate map
map = interp1( linspace( 0, 1, 9 ), map, linspace( 0, 1, n ) ) / 255;

%  load or return colormap
if nargout == 0
  colormap( map );
else
  varargout{ 1 } = map;
end