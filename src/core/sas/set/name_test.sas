%*Please write test code here;;
%*%asserteq( ,%sas_set_name());
%*%assertne( ,%sas_set_name());
%*%assertref( );

%asserteq(,%sas_set_name());
%asserteq(,%sas_set_name(.));
%asserteq(,%sas_set_name(..));

%asserteq(ssaf,%sas_set_name(ssaf));
%asserteq(__dd,%sas_set_name(__dd));
%asserteq(asdm,%sas_set_name(asdm));
%asserteq(ss,%sas_set_name(ss));
%asserteq(ss,%sas_set_name(=.ss));
%asserteq(ss,%sas_set_name(+.ss));

%asserteq(,%sas_set_name(sas.));
%asserteq(,%sas_set_name(SAS.));
%asserteq(,%sas_set_name(sas.));

%asserteq(class,%sas_set_name(sashelp.class));


%asserteq(,%sas_set_name(+.ss.));
%asserteq(,%sas_set_name(sas.sas.ccc));