function sub = subclasses( classname )
%  SUBCLASSES - Find names of subclasses for superclass CLASSNAME.
%
%  Usage :
%    sub = subclasses( classname )
%  Input
%    classname  :  name of superclass
%  Output
%    sub        :  names of derived classes
%                    The function scans through all directories of the
%                    Matlab path and only considers classes that are
%                    defined in subdirectories @subclassname

%  initialize output array
sub = {};

%  read subdirectories
%    alternatively use strsplit( path, pathsep )
subs = transpose( strread( path,'%s', 'delimiter', pathsep ) );
%  keep only subdirectories with 'MNPBEM' in name
subs = subs( cellfun( @( x ) ~isempty( x ), strfind( subs, 'MNPBEM' ) ) );

%  loop over all subdirectories
for p = subs
  %  find classes in subdirectories
  classes = dir( fullfile( p{ : }, '@*' ) );
  for i = 1 : length( classes )
    %  class name
    name = strrep( classes( i ).name, '@', '' );
    %  determine whether builtin class or user-defined class
    if ~exist( name, 'builtin' )
      try
         if any( strcmp( classname, superclasses( name ) ) )
           %  add class name to list
           sub{ end + 1 } = name;
         end
      end
    end
  end
end
