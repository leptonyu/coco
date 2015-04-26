%*Please write test code here;;
%*%asserteq( ,%sas_map_new());
%*%assertne( ,%sas_map_new());
%*%assertref( );


%import(ismacroref);

%global t;
%let t=%sas_map_new();
%asserteq(1,%ismacroref(&t.));
%asserteq(,&&&t..);
%put &t. = &&&t..;
%symdel &t.;