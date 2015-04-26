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


%*test 3;
%sh(%*;);

%*test 4;
%sh(put "*");

%*test 5;
%sh(
);

%*test 6;
%sh(
name=Daniel;
put "Hello, I'm $name" ;
);

%*test 7;
%sh(
name=Daniel;
put 'Hello, I"m $name' ;
);

%*test 8;
%sh(
refxxx=;
ref "#refxxx";
put "$refxxx";
{getpath import}
parsemacro "$" "$refxxx";
print "$refxxx";
ref "#refxxx" clear;
);


%*test 9;
%sh(
()
()
{
sort 'i k m g';
sort 'p j f z'
}
(()())
);

%*test 10;
%sh(
{}{}{}
put '$';
put "$"
);

%* error test;
%sh(%str(%());
%asserteq(Uncomplete (),&SYSERRORTEXT.);
%sh(%str(%)));
%asserteq(Uncomplete (),&SYSERRORTEXT.);
%sh({);
%asserteq(Stack uncomplete stack1={,&SYSERRORTEXT.);
%sh(});
%asserteq(Uncomplete {},&SYSERRORTEXT.);
%sh(%nrstr(%"));
%asserteq(Uncomplete string,&SYSERRORTEXT.);
%sh(%nrstr(%'));
%asserteq(Uncomplete string,&SYSERRORTEXT.);
%put _all_;
%symdel g_sh_openlog;