%*Please write test code here;;
%*%asserteq( ,%sas_list_length());
%*%assertne( ,%sas_list_length());
%*%assertref( );


%import(sas_list_new);
%global ref;
%let ref=%sas_list_new([1,2,3,400]);
%asserteq(4,%sas_list_length(&ref));
%let ref=%sas_list_new([1]);
%asserteq(1,%sas_list_length(&ref));
%let ref=%sas_list_new([]);
%asserteq(0,%sas_list_length(&ref));
%symdel ref;