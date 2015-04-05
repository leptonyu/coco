%macro ismacroref(_refname_);
    %local re;
    %if %sysfunc(compress("&_refname_."))="" %then
        %do;
            %let re=0;
        %end;
    %else %if %symexist(&_refname_.) %then
        %do;
            %let re=1;
        %end;
    %else
        %do;
            %let re=0;
        %end;
    &re.
%mend;