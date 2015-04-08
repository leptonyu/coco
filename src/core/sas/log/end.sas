%import(sas_log_ref);
%import(sas_log_option);

%macro sas_log_end();
    %local opns1 opns2;
    %sas_log_option(opns1, opns2);
    %put 从现在开始恢复默认日志输出!;

    proc printto ;
    run;

    %if %symexist(g_sdk_log_lastref) %then
        %do;
            %sas_log_ref(g_sdk_log_lastref, clear);
            %symdel g_sdk_log_lastref;
        %end;
    options &opns2.;
%mend;