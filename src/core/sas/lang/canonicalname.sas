/**
format macro name
@author Daniel YU
@since 2015-4-5
*/
%macro canonicalname(name);
    %if %length(&name.)=0 %then
        %return;
    %let name=%sysfunc(compress(%lowcase(&name.)));

    %if "%sysfunc(count(&name., .))"="1" %then
        %do;
            %local handler;
            %let handler=%scan(&name., 1, .);
            %let name=%scan(&name., -1, .);

            %if %symexist(g_handler_&handler.) %then
                %do;
                    %let handler=&&g_handler_&handler.;
                %end;
            %else
                %do;
                    %put ERROR: Handler<&handler.> not found!;
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