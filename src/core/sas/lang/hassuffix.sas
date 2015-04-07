%macro hassuffix(str, suffix);
    %local re lens lenp;
    %let lens=%length(&str.);
    %let lenp=%length(&suffix.);
    %let re=0;

    %if &lenp.=0 %then
        %do;
            %let re=1;
        %end;
    %else %if &lens. >=&lenp. and &lenp.>0 %then
        %do;
            %let str=%substr(&str., %eval(&lens.-&lenp.+1));

            %if "&str."="&suffix." %then
                %do;
                    %let re=1;
                %end;
        %end;
    &re.
%mend;