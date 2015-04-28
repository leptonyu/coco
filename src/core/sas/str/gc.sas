/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 10:27:30
* @version 1.0
* @desp    Garbage collector.
*************************************************/
 
%import(sas_str_pool_scan);
 
%macro sas_str_gc();
    %if not %symexist(g_sas_pool) %then %do;
        %return;
    %end;
    %local temp_pool;
    %if not %symexist(g_sas_pool_root) %then %do;
        %let temp_pool=|;
        %goto gc;
    %end;
    %let temp_pool=%sas_str_pool_scan(&g_sas_pool_root.,|);    
%gc:
    %local i v;
    %let i=1;
    %let v=%scan(&g_sas_pool.,&i.,|);
    %do %while("&v."^="");
        %if not %index(&temp_pool.,|&v.|) %then %do;
            %put NOxTE: clean g_sas_pool_&v.=&&&g_sas_pool_&v..;
            %* delete ;
            %if %symexist(g_sas_pool_&v.) %then %symdel g_sas_pool_&v.;
        %end;
        %let i=%eval(&i.+1);
        %let v=%scan(&g_sas_pool.,&i.,|);
    %end;
    %let g_sas_pool=&temp_pool.;
%mend;
