%*Please write test code here;;
%*%asserteq( ,%sas_map_del());
%*%assertne( ,%sas_map_del());
%*%assertref( );

%import(sas_map_new);
%import(ismacroref);

%global t;
%let t=%sas_map_new();
%asserteq(1,%ismacroref(&t.));
%sas_map_del(&t.);
%asserteq(0,%ismacroref(&t.));
%symdel t;