/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:38:07
* @version 1.0
* 
*************************************************/

%import(sas_str_pool_add);

%macro sas_str_register(ref);
    %if %symexist(g_sh) and %symexist(g_sh_pool_&g_sh.) %then %do;
        %let g_sh_pool_&g_sh.=%sas_str_pool_add(&&&g_sh_pool_&g_sh..,&ref.);
        %if not %symexist(g_sas_pool_root) %then %do;
            %global g_sas_pool_root;
            %let g_sas_pool_root=|;
        %end;
        %let g_sas_pool_root=%sas_str_pool_add(&g_sas_pool_root.,&ref.);
    %end;
%mend;
