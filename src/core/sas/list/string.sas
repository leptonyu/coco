/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 12:50:25
* @version 1.0
* 
*************************************************/
 
%macro sas_list_string(list_ref);
    %local value;
    %if %symexist(g_sas_pool_&list_ref.) %then %do;
         %let value=&&&g_sas_pool_&list_ref..;
    %end;%else %do;
         %let value=|;
    %end;
    &value.
%mend;
