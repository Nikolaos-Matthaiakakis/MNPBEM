%  MAKEMNPBEMHELP - Publish help files.
%    To set up the help, you must :
%      1.  Change in Matlab to the main directory of the MNPBEM toolbox.
%      2.  Run the file makemnpbemhelp

%  change to help directory
cd( 'help' );

%  get file names
files = dir( fullfile( '.', '*.m' ) );
%  loop over files and publish them
for i = 1 : length( files )
  publish( files( i ).name, struct( 'evalCode', false ) );
end

%  build searchable database
builddocsearchdb( pwd );
%  return to main directory
cd( '..' );
