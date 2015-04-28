/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:21:13
* @version 1.0
* @desp    create reference.
*************************************************/

%import(sas_str_pool);

%macro sas_str_ref();
    %sas_str_pool(|,is_ref=0)
%mend;
