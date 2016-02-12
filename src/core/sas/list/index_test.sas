%*Please write test code here;;
%*%asserteq( ,%sas_list_index());
%*%assertne( ,%sas_list_index());
%*%assertref( );

%import(sas_list_new);
%global ref;
%let ref=%sas_list_new([1,2,3,400]);

%asserteq(1,%sas_list_index(&ref,1));
%asserteq(2,%sas_list_index(&ref,2));
%asserteq(3,%sas_list_index(&ref,3));
%asserteq(400,%sas_list_index(&ref,4));
%asserteq(,%sas_list_index(&ref,0));
%asserteq(,%sas_list_index(&ref,5));
%symdel ref;