%let g_=/;
%let g_root=&_SASWS_.&g_.;
%let g_src=&g_root.src&g_.;
%let g_src_self=&g_root.self&g_.;

/* include import*/
%inc "&g_src.sas/lang/import.sas";