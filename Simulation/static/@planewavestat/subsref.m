function val = subsref( obj, s )
%  Class properties and derived properties for planwavestat objects.
%
%  Usage for obj = planewavestat :
%    obj.pol                :  light polarization
%    obj( p, enei )         :  external potential for use in bemstat
%    obj.field( p, enei )   :  electric field
%    obj.scattering( sig )  :  scattering cross section (use also obj.sca)
%    obj.absorption( sig )  :  absorption cross section (use also obj.abs)
%    obj.extinction( sig )  :  extinction cross section (use also obj.ext)

switch s( 1 ).type
%%  electric field and light polarization  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        val = field( obj, s( 2 ).subs{ : } );
      case { 'sca', 'scattering' }
        val = scattering( obj, s( 2 ).subs{ : } );
      case { 'abs', 'absorption' }
        val = absorption( obj, s( 2 ).subs{ : } );
      case { 'ext', 'extinction' }
        val = extinction( obj, s( 2 ).subs{ : } );
      otherwise
        val = builtin( 'subsref', obj, s );
    end
    
%%  external potential    
  case '()'
    val = potential( obj, s( 1 ).subs{ : } );
end
