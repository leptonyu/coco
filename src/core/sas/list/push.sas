/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 12:36:23
* @version 1.0
* 
*************************************************/

%import(sas_str_new);
%import(sas_list_string);

%macro sas_list_push(list_ref,value);
   %local flag;
   %if not %symexist(g_sas_pool_&list_ref.) %then %do;
      %let flag=0;
      %goto exit;
   %end;
   %let flag=1;
   %local key;
   %let key=%sas_str_new(%superq(value));
   %let g_sas_pool_&list_ref.=%sas_list_string(&list_ref.)&key.|;
%exit:
   &flag.
%mend;
