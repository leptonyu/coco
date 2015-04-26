%*Please write test code here;;
%*%asserteq( ,%depall());
%*%assertne( ,%depall());
%*%assertref( );


%global t;

%depall(import,t);
%assertne(,&t.);

%depall(nvalid,t);
%asserteq(,&t.);

%depall(dep,t);
%assertne(,&t.);

%symdel t;