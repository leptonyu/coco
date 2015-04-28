/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 12:39:32
* @version 1.0
* 
*************************************************/

%import(sas_list_string);

%macro sas_list_pop(list_ref);
    %local value;
    %local i v temp origin;
    %let origin=%sas_list_string(&list_ref.);
    %let temp=|;
    %let i=1;
    %let v=%scan(&origin.,-&i.,|);
    %do %while("&v."^="");
        %if &i.=1 %then %do;
            %if %symexist(g_sas_pool_&v.) %then %do;
                %let value=%superq(g_sas_pool_&v.);
            %end;
        %end;%else %do;
            %let temp=|&v.&temp.;
        %end;
        %let i=%eval(&i.+1);
        %let v=%scan(&origin.,-&i.,|);
    %end;
    %if %symexist(g_sas_pool_&list_ref.) %then %do;
        %let g_sas_pool_&list_ref.=&temp.;
    %end;
%exit:
    %superq(value)
%mend;
