function varargout = subsref( obj, s )
%  Access compound object properties and convert compoint arrays.
%
%  Usage for obj = compoint :
%    val = obj.PropertyName
%      Pass PropertyName to compound
%    val = obj( valpt, valdef )    
%      Given a value array valpt computed for the compoint object, a val
%      array is returned that has the same number of elements as the
%      positions pos provided in the initialization of compoint.  This
%      function allows to convert between the position indices and the
%      internal compoint indices.  Elements that are unset in compstruct
%      are set to the (optional) valdef value (NaN on default).

switch s( 1 ).type
  case '.'
    switch s( 1 ).subs
      case { 'pin', 'layer' }
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
      otherwise
        [ varargout{ 1 : nargout } ] = subsref@compound( obj, s );
    end
  case '()'
    %  extract input
    valpt = s( 1 ).subs{ 1 };
    %  default value for unset elements
    if length( s( 1 ).subs ) == 2
      valdef = s( 1 ).subs{ 2 };
    else
      valdef = NaN;
    end
    
    %  allocate val array
    siz = size( valpt );
    %  allocate val array
    if isnan( valdef )
      val =  nan( [ obj.npos, siz( 2 : end ) ] );
    else
      val = ones( [ obj.npos, siz( 2 : end ) ] ) * valdef;
    end
    
    %  convert between compoint and original position indices
    for i = 1 : subsref( obj, substruct( '.', 'np' ) )
      ind = subsref( obj, substruct( '.', 'index', '()', { i } ) );
      val( obj.ind{ obj.mask( i ) }, : ) = valpt( ind, : );
    end
    
    varargout{ 1 } = val;
end
