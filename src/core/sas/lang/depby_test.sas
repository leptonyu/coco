%*Please write test code here;;
%*%asserteq( ,%depby());
%*%assertne( ,%depby());
%*%assertref( );

%global t;
%depby(option,t);
%put &t.;
%symdel t;
