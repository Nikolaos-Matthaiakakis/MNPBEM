function varargout = subsref( obj, s )
%  Class properties and derived properties for planwaveret objects.
%
%  Usage for obj = planewaveret :
%    obj.pol                :  light polarization
%    obj.dir                :  light propagation direction
%    obj( p, enei )         :  external potential for use in bemret
%    obj.field( p, enei )   :  electric and magnetic fields
%    obj.scattering( sig )  :  scattering cross section (use also obj.sca)
%    obj.absorption( sig )  :  absorption cross section (use also obj.abs)
%    obj.extinction( sig )  :  extinction cross section (use also obj.ext)

switch s( 1 ).type
%%  electric field and light polarization  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field( obj, s( 2 ).subs{ : } );
      case { 'sca', 'scattering' }
        [ varargout{ 1 : nargout } ] = scattering( obj, s( 2 ).subs{ : } );
      case { 'ext', 'extinction' }
        [ varargout{ 1 : nargout } ] = extinction( obj, s( 2 ).subs{ : } );
      case { 'abs', 'absorption' }
        [ varargout{ 1 : nargout } ] = absorption( obj, s( 2 ).subs{ : } );                               
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end
    
%%  external potential    
  case '()'
    varargout{ 1 } = potential( obj, s( 1 ).subs{ : } );
end
