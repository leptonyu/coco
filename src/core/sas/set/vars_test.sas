%*Please write test code here;;
%*%asserteq( ,%sas_set_vars());
%*%assertne( ,%sas_set_vars());
%*%assertref( );

%global v;
%let v=;
%sas_set_vars(sashelp.class,v);
%put &v.;
%assertne(,&v.);

%let v=;
%sas_set_vars(sashelp.cars,v);
%put &v.;
%assertne(,&v.);

%let v=;
%sas_set_vars(sashelp.carx,v);
%put &v.;
%asserteq(,&v.);

%let v=;
%sas_set_vars(..,v);
%put &v.;
%asserteq(,&v.);

%symdel v;
