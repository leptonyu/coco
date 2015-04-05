%global g_ g_src g_src_1;
%let g_=/;
%let g_src=&_SASWS_./src/sas/;
%let g_src_1=&_SASWS_./src/test/;
%*let g_src_2=;
%* ...;
%*let g_src_9=;
%inc "&g_src.sas/lang/import.sas";
%import(sh);