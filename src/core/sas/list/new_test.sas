%*Please write test code here;;
%*%asserteq( ,%sas_list_new());
%*%assertne( ,%sas_list_new());
%*%assertref( );


%global t;
%sh(
{sas_list_new}
put _all_;
);

%put _global_;
%let t=&g_sh_last.;
%import(sas_str_gc);
%sas_str_gc();
%asserteq(0,%symexist(g_sas_pool_&t.));
%symdel t;

%put _global_;