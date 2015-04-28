/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 10:43:39
* @version 1.0
* @desp    del word from list.
* @inner   
*************************************************/
 
%macro sas_str_pool_del(list,target);
    %sysfunc(compress(%sysfunc(tranwrd(&list.,|&target.|, |))))
%mend;
