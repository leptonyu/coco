%*Please write test code here;;
%*%asserteq( ,%sas_str_ref());
%*%assertne( ,%sas_str_ref());
%*%assertref( );

%import(sas_str_unregister);

%global t;

%let t=%sas_str_ref();
%put g_sas_pool_&t.=&&&g_sas_pool_&t.;
%assertne(0,%symexist(g_sas_pool_&t.));
%put _global_;
%sas_str_unregister(&t.);
%assertne(0,%symexist(g_sas_pool_&t.));
%symdel t;