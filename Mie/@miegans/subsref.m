function val = subsref( obj, s )
%  Class properties and derived properties for miegans objects.
%
%  Usage for obj = miegans :
%    obj.scattering( enei )  :  scattering cross section (use also obj.sca)
%    obj.absorption( enei )  :  absorption cross section (use also obj.abs)
%    obj.extinction( enei )  :  extinction cross section (use also obj.ext)

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case { 'sca', 'scattering' }
        val = scattering( obj, s( 2 ).subs{ : } );
      case { 'abs', 'absorption' }
        val = absorption( obj, s( 2 ).subs{ : } );
      case { 'ext', 'extinction' }
        val = extinction( obj, s( 2 ).subs{ : } );
      otherwise
        val = builtin( 'subsref', obj, s );
    end
    
end
