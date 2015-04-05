%macro sas_str_addpost(string, postfix, sep=, sep2);
    %if %length(&sep.)=0 %then
        %let sep=%str( );

    %if %length(&sep2.)=0 %then
        %let sep2=&sep.;
    %sysfunc(tranwrd(%sysfunc(compbl(&string.)), &sep., 
        &postfix.&sep2.))&postfix.
%mend;