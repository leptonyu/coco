%inc "&_SASWS_./autoexec.sas";
%import();
%import(import);
%import(IMPORT);
%import(OPTION);
%import(sas_lang_q);
%import(sas_lang_x_x);
%import(q);
%import(x);
%import(getpath);
%import(formatname);
%import(ref);
%import(option);
%import(test);

%test;

%asserteq(a,a);
%assertne(a,b);
