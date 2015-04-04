%macro sas_log_ref(_file_, clear);
    %if not %symexist(&_file_.) %then
        %return;
    %else %if %length(&&&_file_.)=0 or %bquote(&&&_file_.)=__err %then
        %do;
            %let &_file_.=__err;
            %return;
        %end;

    %if %length(&clear.) %then
        %do;

            %if not %symexist(g_sdk_log_ref) %then
                %return;

            %if %index(&g_sdk_log_ref., |&&&_file_.|) %then
                %do;
                    %if &sysver.<9.2 %then
                        %let g_sdk_log_ref=%sysfunc(compress(%sysfunc(tranwrd(&g_sdk_log_ref., 
                            |&&&_file_.|, |))));
                    %else
                        %let g_sdk_log_ref=%sysfunc(prxchange(%bquote(s/\|&&&_file_.\|/|/), 
                            -1, &g_sdk_log_ref.));
                    %local name;
                    %let name=&&&_file_.;
                    %let sysrc=%sysfunc(filename(name));
                %end;
        %end;
    %else
        %do;

            %if %sysfunc(fileref(&_file_.))>0 %then
                %do;

                    %if not %symexist(g_sdk_log_ref) %then
                        %do;
                            %global g_sdk_log_ref;
                            %let g_sdk_log_ref=|;
                        %end;
                    %local name;
                    %let name=__log%sysfunc(int(%sysfunc(ranuni(-1))*4096), 
                        hex3.);

                    %do %while(%index(&g_sdk_log_ref., |&name.|));
                        %let name=__log%sysfunc(int(%sysfunc(ranuni(-1))*4096), 
                            hex3.);
                    %end;

                    %if %sysfunc(filename(name, &&&_file_.)) %then
                        %do;
                            %put error: 分配失败！;
                            %let &_file_.=__err;
                        %end;
                    %else
                        %do;
                            %let &_file_.=&name.;
                            %let g_sdk_log_ref=&g_sdk_log_ref.&name.|;
                        %end;
                %end;
        %end;

    /*	%put error: &g_sdk_log_ref.;*/
%mend;