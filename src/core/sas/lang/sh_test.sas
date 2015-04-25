%*Please write test code here;;
%*%asserteq( ,%sh());
%*%assertne( ,%sh());
%*%assertref( );
%global g_sh_openlog;
%let g_sh_openlog=1;
%* test empty;
%sh();

%* test invoke macro;
%sh(
put hello "xxx"
);

%*Test variables;
%sh(
abc=sh;
help "$abc"
);


%sh(%*;);

%sh(put "*");

%sh(
);

%sh(
name=Daniel;
put "Hello, I'm $name" ;
);

%sh(
name=Daniel;
put 'Hello, I"m $name' ;
);

%symdel g_sh_openlog;