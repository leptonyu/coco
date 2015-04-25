%*Please write test code here;;
%*%asserteq( ,%sh());
%*%assertne( ,%sh());
%*%assertref( );

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