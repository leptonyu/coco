%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;
%sh(
{ sas_list_new '[1,2,3]';
  g="$";
  list.tostr "$g";
  list.pop "$g";
  list.tostr "$g";
  list.pop "$g";
  list.tostr "$g";
  list.pop "$g";
  list.push "$g" 'hello';
  list.tostr "$g";
  list.pop "$g";
  list.tostr "$g";
}
);