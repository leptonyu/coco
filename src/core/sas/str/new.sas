/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:20:00
* @version 1.0
* 
*************************************************/

%import(sas_str_pool);

%macro sas_str_new(value);
    %sas_str_pool(%superq(value),is_ref=1)
%mend;
