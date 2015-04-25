%*Please write test code here;;
%*%asserteq( ,%sas_lib_name());
%*%assertne( ,%sas_lib_name());
%*%assertref( );


%asserteq(work,%sas_lib_name());
%asserteq(work,%sas_lib_name(.));
%asserteq(work,%sas_lib_name(..));
%asserteq(work,%sas_lib_name(ssaf));
%asserteq(work,%sas_lib_name(__dd));
%asserteq(work,%sas_lib_name(asdm));
%asserteq(work,%sas_lib_name(ss));
%asserteq(work,%sas_lib_name(=.ss));
%asserteq(work,%sas_lib_name(+.ss));

%asserteq(sas,%sas_lib_name(sas.));
%asserteq(sas,%sas_lib_name(SAS.));
%asserteq(sas,%sas_lib_name(sas.));

%asserteq(sashelp,%sas_lib_name(sashelp.class));