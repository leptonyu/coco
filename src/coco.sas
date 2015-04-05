%let g_=/;
%let g_src=&_SASWS_./src/core/;
%let g_src_1=&_SASWS_./src/main/;
%*let g_src_2=;
%* ...;
%*let g_src_9=;

%let g_handler_f=sas_file_;
%let g_handler_log=sas_log_;
%let g_handler_l=sas_log_;
%inc "&g_src.sas/lang/import.sas";
%import(sh);
%import(test);