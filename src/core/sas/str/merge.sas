/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro sas_str_merge(string1, string2, midfix, prefix, postfix, id=1, 
        sep=%str( ));
    %local str1 str2;
    %let str1=%scan(&string1., &id., %str(&sep.));
    %let str2=%scan(&string2., &id., %str(&sep.));

    %if %length(&str1.) or %length(&str2.) %then
        %do;
            &prefix.&str1.&midfix.&str2.&postfix. %sas_str_merge(&string1., 
                &string2., &midfix., &prefix., &postfix., id=%eval(&id.+1), 
                sep=&sep.) 
        %end;
%mend;