function varargout = subsref( obj, s )
%  Class properties and derived properties for planwaveretmirror objects.
%
%  Usage for obj = planewaveretmirror :
%    obj.pol                :  light polarization
%    obj.dir                :  light propagation direction
%    obj.medium             :  plane wave excitation through given medium
%    obj( p, enei )         :  external potential for use in bemretmirror
%    obj.field( p, enei )   :  electric and magnetic fields
%    obj.sca( sig )         :  scattering cross section
%    obj.abs( sig )         :  absorption cross section
%    obj.ext( sig )         :  extinction cross section

switch s( 1 ).type
  %  electric field and light polarization  
  case '.'  
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field( obj, s( 2 ).subs{ : } );
      case 'full'
        varargout{ 1 } = full(  obj, s( 2 ).subs{ : } );
      case { 'sca', 'ext', 'abs' } 
        [ varargout{ 1 : nargout } ] = subsref( obj.exc,  ...
            substruct( '.', s( 1 ).subs,                  ...
                       '()', { full( obj, s( 2 ).subs{ : } ) } ) );
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end
    
  %  external potential    
  case '()'
    varargout{ 1 } = potential( obj, s( 1 ).subs{ : } );
end
