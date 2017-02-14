%inc "&_SASWS_./autoexec.sas";

%let g_sh_openlog=0;
%let g_debug=0;
%sh(
test _all_
);