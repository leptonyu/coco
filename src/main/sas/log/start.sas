/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(sas_log_option);
%import(sas_log_ref);

%macro sas_log_start(file, option);
    %local option optbak;
    %sas_log_option(option,optbak);
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