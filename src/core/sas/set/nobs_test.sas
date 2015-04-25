%*Please write test code here;;
%*%asserteq( ,%sas_set_nobs());
%*%assertne( ,%sas_set_nobs());
%*%assertref( );


%asserteq(0,%sas_set_nobs());

%assertne(0,%sas_set_nobs(sashelp.class));
%assertne(0,%sas_set_nobs(sashelp.class sashelp.cars));
%assertne(0,%sas_set_nobs(sashelp.class    sashelp.cars ));


%assertne(0,%sas_set_nobs(sashelp.class ...   sashelp.cars ));


%global x y z;

%let x=%sas_set_nobs(sashelp.class);
%let y=%sas_set_nobs(sashelp.cars);
%let z=%sas_set_nobs(sashelp.class sashelp.cars);

%asserteq(&z.,%eval(&x.+&y.));

%symdel x y z;
