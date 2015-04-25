%*Please write test code here;;
%*%asserteq( ,%sas_set_index());
%*%assertne( ,%sas_set_index());
%*%assertref( );

%global indexx;

%let indexx=;
%sas_set_index(sashelp.aarfm, indexx);
%asserteq(locale key,&indexx.);

%let indexx=;
%sas_set_index(sashelp.class, indexx);
%asserteq(,&indexx.);
