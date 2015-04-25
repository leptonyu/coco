%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;
%sh(
abc=;
dep=;
put _local_;
put _global_;
put 'g_sh=&g_sh.';
sh 'put "g_sh=%str(&)g_sh."'
);
%put _global_;
