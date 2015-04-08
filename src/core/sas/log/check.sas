%import(sas_log_ref);
%import(sas_log_option);
%import(sas_log_tofile);

%macro sas_log_check(log, file, type);
    %local opns1 opns2;
    %sas_log_option(opns1, opns2);
    %local logfile;
    %let logfile=&log.;
    %sas_log_ref(log);

    %if not %index(&log., __err)=1 %then
        %do;
            %sas_log_ref(file);

            %if not %symexist(g_sdk_log_err) %then
                %global g_sdk_log_err;

            data _null_;
                infile &log. end=eof;

                %if not %index(&file., __err)=1 %then
                    %do;
                        file &file. mod;
                    %end;
                input;

                if _n_=1 then
                    do;
                        err=0;

                        %if %symexist(g_sas_date) %then
                            %do;
                                date=put(&g_sas_date., yymmdd10.);
                            %end;
                        %else
                            %do;
                                date=put(date(), yymmdd10.);
                            %end;
                        time=put(time(), time8.);
                        put date time '正在检查日志文件' "%sysfunc(pathname(&log.))";
                    end;

                if 
                %if %length(&type.)=0 %then
                    %do;
                        prxmatch('/^error:?\s|^stderr\s|\b无效的数据\b|^fatal:\s/i', 
                            _infile_) %end;
                %else
                    %do;
                        prxmatch('/^error:?\s|^stderr\s|^warning:\s|\b未初始化\b|\b无效\b|^fatal:\s/i', 
                            _infile_) %end;
                then do;
                err+1;
                put err _infile_;
            end;

            if eof then
                do;
                    call symput('g_sdk_log_err', err);

                    %if %symexist(g_sas_date) %then
                        %do;
                            date=put(&g_sas_date., yymmdd10.);
                        %end;
                    %else
                        %do;
                            date=put(date(), yymmdd10.);
                        %end;
                    time=put(time(), time8.);

                    if err then
                        put date time 
                            /"error: 日志%sysfunc(pathname(&log.))有错，请详细检查。";
                    else
                        put date time "日志文件%sysfunc(pathname(&log.))正常。";
                end;
            retain err;
        run;

        %if &g_sdk_log_err. and not %index(&file., __err)=1 %then
            %put error: 日志%sysfunc(pathname(&log.))有错，请详细检查。;
        %sas_log_ref(log, clear);
        %sas_log_ref(file, clear);
    %end;
%else
    %put error: 文件&logfile.分配失败!;
options &opns2.;
%mend;