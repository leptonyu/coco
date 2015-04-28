/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:32:51
* @version 1.0
* 
*************************************************/
 
%macro sas_str_pool_add(list,target);
    %if not %index(&list.,|&target.|) %then %do;
        %let list=&list.&target.|;
    %end;
    &list.
%mend;
