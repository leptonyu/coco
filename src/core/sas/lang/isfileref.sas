%macro isfileref(ref);
    %local re;
    %let re=0;

    %if %length(&ref.) %then
        %do;
            %if %sysfunc(fileref(&ref.))<=0 %then
                %do;
                    %let re=1;
                %end;
        %end;
   &re.
%mend;