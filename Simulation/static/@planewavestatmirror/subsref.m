function val = subsref( obj, s )
%  Class properties and derived properties for PLANWAVESTATMIRROR objects.
%
%  Usage for obj = planewavestatmirror :
%    obj.pol                :  light polarization
%    obj( p, enei )         :  external potential for use in bemstatmirror
%    obj.field( p, enei )   :  electric field
%    obj.full( val )        :  expand compstructmirror object for full particle
%    obj.sca( sig )         :  scattering cross section
%    obj.abs( sig )         :  absorption cross section
%    obj.ext( sig )         :  extinction cross section

switch s( 1 ).type
  %  electric field and light polarization  
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
      case 'full'
        val = full( obj, s( 2 ).subs{ : } );
      otherwise
        val = builtin( 'subsref', obj, s );
    end
    
  %  external potential    
  case '()'
    val = potential( obj, s( 1 ).subs{ : } );
end
