/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-27 12:16:56
 * @version 1.0
 * @desp    String resource pool
 * @inner
 *************************************************/

%import(sas_str_pool_del);

%macro sas_str_pool(str,is_ref=1);
    %if not %symexist(g_sas_pool) %then %do;
        %global g_sas_pool;
        %let g_sas_pool=|;
    %end;
    %if not %symexist(g_sas_pool_root) %then %do;
        %global g_sas_pool_root;
        %let g_sas_pool_root=|;
    %end;
    %if "&is_ref."^="0" %then %do;
        %let is_ref=1;
    %end;%else %do;
        %let str=%sysfunc(int(%sysfunc(ranuni(-1))*16777216));
    %end;
    %local key index len max;
    %let len=8;
    %let max=%sysfunc(floor(65535/(&len.+3)));
    %if (%sysfunc(countw(&g_sas_pool.)) >= &max.) %then %do;
        %put ERROR: String pool overflow!;
        %put &g_sas_pool.;
        %abort;
    %end;
    %let key=%sysfunc(int(&is_ref.),hex2.)%sysfunc(md5(%superq(str)), hex&len..);
    %let index=1;

    %do %while(1);
        %if not %symexist(g_sas_pool_&key.) %then
            %do;
                %goto exit;
            %end;
        %if "%superq(str)" eq "%superq(g_sas_pool_&key.)" %then
            %do;
                %goto ok;
            %end;
        %let index=%eval(&index.+1);

        %if &index.>32 %then
            %do;
                %put ERROR: String pool overflow!;
                %abort;
            %end;
        %let key=%sysfunc(int(&is_ref.),hex2.)%sysfunc(md5(&key.&index.), hex&len..);
    %end;
%exit:
    %global g_sas_pool_&key.;
    %if &is_ref. %then %do;
    %let g_sas_pool_&key.=%superq(str);
    %end;%else %do;
    %let g_sas_pool_&key.=|;
    %end;
    %let g_sas_pool=&g_sas_pool.&key.|;
%ok:
    &key.
%mend;
