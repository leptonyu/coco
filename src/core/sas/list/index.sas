/*************************************************
 * Copyright(c) 2016 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2016-02-10 00:56:22
 * @version 1.0
 *
 *************************************************/

%import(sas_list_string);

%macro sas_list_index(list_ref, index);
    %let list_ref=%scan(%sas_list_string(&list_ref.), &index, |);
    %local value;

    %if %symexist(g_sas_pool_&list_ref.) %then
        %do;
            %let value=%superq(g_sas_pool_&list_ref.);
        %end;
    &value.
%mend;
