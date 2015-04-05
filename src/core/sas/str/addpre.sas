%macro sas_str_addpre(string, prefix, sep, sep2);
    %if %length(&sep.)=0 %then
        %let sep=%str( );

    %if %length(&sep2.)=0 %then
        %let sep2=&sep.;
    &prefix.%sysfunc(tranwrd(%sysfunc(compbl(&string.)), &sep., 
        &sep2.&prefix.))
%mend;