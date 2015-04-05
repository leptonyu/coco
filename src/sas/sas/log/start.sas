%import(sas_log_options);
%import(sas_log_ref);

%macro sas_log_start(file, option);
    %local opns1 opns2;
    %sas_log_options(opns1, opns2);
    %local logfile;
    %let logfile=&file.;
    %sas_log_ref(file);

    %if not %index(&file., __err)=1 %then
        %do;
            %put 现在开始日志定向到 %sysfunc(pathname(&file.)) 文件!;

            proc printto log=&file. &option.;
            run;

            %if %symexist(g_sdk_log_lastref) %then
                %do;
                    %ssas_log_refg_sdk_log_lastref, clear);
                %end;
            %else
                %global g_sdk_log_lastref;
            %let g_sdk_log_lastref=&file.;
        %end;
    %else
        %put error: 文件&logfile.分配失败!;
    options &opns2.;
%mend;