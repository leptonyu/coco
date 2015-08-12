%*Please write test code here;;
%*%asserteq( ,%sas_list_tostr());
%*%assertne( ,%sas_list_tostr());
%*%assertref( );

%import(sas_list_new);
%import(sas_list_push);
%global g_xxx g_rc;
%let g_xxx=%sas_list_new([0]);
%let g_rc=%sas_list_push(&g_xxx.,123);
%let g_rc=%sas_list_push(&g_xxx.,456);
%put %sas_list_tostr(&g_xxx.);
%asserteq("[0,123,456]","%sas_list_tostr(&g_xxx.)");
%let g_xxx=%sas_list_new([0,1,2]);
%asserteq("[0,1,2]","%sas_list_tostr(&g_xxx.)");
