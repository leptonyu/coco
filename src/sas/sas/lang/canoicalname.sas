/**
format macro name
@author Daniel YU
@since 2015-4-5
*/
%macro canoicalname(name);
    %if %length(&name.)=0 %then
        %return;
    %let name=%sysfunc(compress(%lowcase(&name.)));
    %local saslang;
    %let saslang=sas_lang_;

    %if %index(&name., &saslang.)=1 %then
        %do;
            %let name=%substr(&name., %eval(%length(&saslang.)+1));
            %if %index(&name., _)>0 %then
                %let name=&saslang.&name.;
        %end;
    &name.
%mend;