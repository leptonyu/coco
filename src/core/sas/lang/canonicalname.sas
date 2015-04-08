/**
Get the canonical name of the given name.It has a mechanism to
simply the macro name. Global macro variables such as g_handler_xxx
used to be simplify the macro name.
%let g_handler_l=sas_log_
l.start means sas_log_start
l.end means sas_log_end
then this macro transfer l.start to sas_log_start. It will find l.
to check whether the global macro variable g_handler_l exists, if not,
it will return nothing, which means transfer failed, or it will return
the value of g_handler_l contact the rest of l.start which is start.
And then it returns sas_log_start.
@author Daniel YU
@since 2015-4-5
*/
%macro canonicalname(name);
    %let name=%qcmpres(%lowcase(&name.));

    %if %length(&name.)=0 %then
        %return;

    %if "%sysfunc(count(&name., .))"="1" %then
        %do;
            %local len;
            %let len=%index(&name., .);

            %if &len.=1 or &len.=%length(&name.) %then
                %return;
            %local handler;
            %let handler=%scan(&name., 1, .);
            %let name=%scan(&name., 2, .);

            %if %length(&handler.)=0 %then
                %let handler=%str();
            %else %if %symexist(g_handler_&handler.) %then
                %do;
                    %let handler=&&g_handler_&handler.;
                %end;
            %else
                %do;
                    %put WARNING: Handler<&handler.> not found!;
                    %return;
                %end;
            %let name=&handler.&name.;
        %end;
    %local saslang;
    %let saslang=sas_lang_;

    %if %index(&name., &saslang.)=1 %then
        %do;
            %let name=%substr(&name., %eval(%length(&saslang.)+1));

            %if %index(&name., _)>0 %then
                %let name=&saslang.&name.;
        %end;
    %* check if name is valid.;

    %if %nvalid(&name.) %then
        %do;
            &name.
    %end;
%mend;