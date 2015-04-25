%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;
%sh(
name=Daniel;
put "Hello, I'm $name" ;
);