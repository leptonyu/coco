%*Please write test code here;;
%*%asserteq( ,%isfileref());
%*%assertne( ,%isfileref());
%*%assertref( );

%import(ref);

%global fileref;
%asserteq(0,%isfileref(&fileref.));
%ref(fileref);
%asserteq(1,%isfileref(&fileref.));
%ref(fileref,clear);
%asserteq(0,%isfileref(&fileref.));
%symdel fileref;