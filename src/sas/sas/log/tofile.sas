%import(sas_log_ref);
%import(sas_log_options);

%macro sas_log_tofile(file, content, type);
    %local opns1 opns2;
    %sas_log_options(opns1, opns2);
    %local logfile;
    %let logfile=&file.;
    %sas_log_ref(file);

    %if not %index(&file., __err)=1 %then
        %do;

            data _null_;
                file &file. mod;

                %if %length(&type.)=0 %then
                    %do;

                        %if %symexist(g_sas_date) %then
                            %do;
                                date=put(&g_sas_date., yymmdd10.);
                            %end;
                        %else
                            %do;
                                date=put(date(), yymmdd10.);
                            %end;
                        time=put(time(), time8.);
                        put date time " &content.";
                    %end;
                %else
                    %do;
                        put "&content.";
                    %end;
            run;

            %sas_log_ref(file, clear);
        %end;
    %else
        %put error: 文件&logfile.分配失败!;
    options &opns2.;
%mend;