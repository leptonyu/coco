%inc "&_SASWS_./autoexec.sas";
%let g_src_9=&_SASWS_./src/test/;

%test(import);
%test(canonicalname);
%test(getpath);

