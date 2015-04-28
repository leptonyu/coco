/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:41:45
* @version 1.0
* 
*************************************************/

%import(sas_str_pool_del);

%macro sas_str_unregister(ref);
    %if %symexist(g_sas_pool_root) %then %do;
      %local i v;
      %let i=1;
      %let v=%scan(&ref.,&i.,|);
      %do %while("&v."^="");
          %let g_sas_pool_root=%sas_str_pool_del(&g_sas_pool_root.,&v.);
          %let i=%eval(&i.+1);
          %let v=%scan(&ref.,&i.,|);
      %end;
    %end;
%mend;
