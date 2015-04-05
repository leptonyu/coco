%macro sas_str_addmid(string, midfix, sep);
    %if %length(&sep.)=0 %then
        %let sep=%str( );
    %sysfunc(tranwrd(%sysfunc(compbl(&string.)), %str(&sep.), %str(&midfix.)))
%mend;