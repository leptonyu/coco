%macro nvalid(name);
    %local rc;

    %if %length(&name.)=0 %then
        %do;
            %let rc=0;
        %end;
    %else
        %do;
            %let rc=%qsysfunc(nvalid(&name.));
        %end;
    &rc.
%mend;