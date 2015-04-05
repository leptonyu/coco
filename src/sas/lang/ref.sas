%macro ref(_file_, clear);
    %if not %symexist(&_file_.) %then
        %do;
            %put ERROR: Macro &_file_. not exists!;
            %return;
        %end;

    %if %length(&clear.) %then
        %do;

            %if %length(&&&_file_.)=0 or not %symexist(g_ref) %then
                %do;
                    %put NOTE: No refence need to delete.;
                    %return;
                %end;

            %if %index(&g_ref., |&&&_file_.|) %then
                %do;
                    %let g_ref=%sysfunc(compress(%sysfunc(tranwrd(&g_ref., 
                        |&&&_file_.|, |))));
                    %let sysrc=%sysfunc(filename(&_file_.));
                %end;
        %end;
    %else
        %do;

            %if not %symexist(g_ref) %then
                %do;
                    %global g_ref;
                    %let g_ref=|;
                %end;
            %local name;
            %let name=_%sysfunc(int(%sysfunc(ranuni(-1))*16777216), hex6.)_;

            %do %while(%index(&g_ref., |&name.|));
                %let name=_%sysfunc(int(%sysfunc(ranuni(-1))*16777216), hex6.)_;
            %end;

            %if %length(&&&_file_.)=0 %then
                %do;

                    %if %sysfunc(filename(name, , temp)) %then
                        %do;
                            %put ERROR: file allocate failed!;
                            %let &_file_.=__err;
                        %end;
                    %else
                        %do;
                            %let &_file_.=&name.;
                            %let g_ref=&g_ref.&name.|;
                        %end;
                %end;
            %else
                %do;

                    %if %sysfunc(fileref(&&&_file_.))<=0 %then
                        %do;
                            %put WARNING: file has bean already allocated;
                            %return;
                        %end;

                    %if %sysfunc(filename(name, &&&_file_.)) %then
                        %do;
                            %put ERROR: file allocate failed!;
                            %let &_file_.=__err;
                        %end;
                    %else
                        %do;
                            %let &_file_.=&name.;
                            %let g_ref=&g_ref.&name.|;
                        %end;
                %end;
        %end;
%mend;