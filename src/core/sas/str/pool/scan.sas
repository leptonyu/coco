/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:01:04
* @version 1.0
* 
*************************************************/

%import(hasprefix);

%macro sas_str_pool_scan(pool_root,temp_pool);
    %local i root;
    %let i=1;
    %let root=%scan(&pool_root.,&i.,|);
    %do %while("&root."^="");
        %if not %index(&temp_pool.,|&root.|) %then %do;
            %let temp_pool=&temp_pool.&root.|;
            %if %hasprefix(&root.,00) %then %do;
                %if %symexist(g_sas_pool_&root.) %then %do;
                    %let temp_pool=%sas_str_pool_scan(&&&g_sas_pool_&root..,&temp_pool.);
                %end;
            %end;
        %end;
        %let i=%eval(&i.+1);
        %let root=%scan(&pool_root.,&i.,|);
    %end;
    &temp_pool.
%mend;
