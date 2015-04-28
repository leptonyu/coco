/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:27:57
* @version 1.0
* 
*************************************************/

%import(sas_str_ref);
%import(sas_str_register);

%macro sas_list_new();
    %local ref rc;
    %let ref=%sas_str_ref();
    %let rc=%sas_str_register(&ref.);
    &ref.
%mend;
