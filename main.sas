%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;
%let g_debug=0;
%sh({
g=[123,"99o",kk];
list.tostr "$g"
});