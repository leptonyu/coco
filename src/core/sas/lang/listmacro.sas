/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* @desp    list all macros, will cache result.
*************************************************/

%import(ismacroref);
%import(sort);
%import(hassuffix);
%import(canonicalname);
%import(sas_file_list);

%macro listmacro(_lst_, id=);
    %if not %ismacroref(&_lst_.) %then %do;
        %put WARNING: parameter error;
        %return;
    %end;
    %local i;
    %if "&id."="" %then
        %do;
            %local abc;
            %do i=0 %to 9;
                %let abc=;
                %listmacro(abc, id=&i.);
                %let &_lst_.=&&&_lst_.. &abc.;
            %end;
            %let &_lst_.=%sort(&&&_lst_..,uniq=1);
            %return;
        %end;
    %if %symexist(g_src_list_&id.) %then %do;
        %goto exit;
    %end;%else %do;
        %global g_src_list_&id.;
    %end;
    %local src;

    %if "&id."="0" %then
        %do;
            %let src=&g_src.;
        %end;
    %else
        %do;
            %if not %symexist(g_src_&id.) %then
                %do;
                    %return;
                %end;
            %let src=&&&g_src_&id.;
        %end;
    %local files;
    %sas_file_list(&src., files, suffix=.sas);
    %local file;
    %let i=1;
    %let file=%scan(&files., &i., %str( ));

    %do %while("&file."^="");
        %if not %hassuffix(&file., _test.sas) and "&file."^=".sas" %then
            %do;
                %let file=%substr(&file., 1, %length(&file.)-4);
                %let file=%canonicalname(%sysfunc(tranwrd(&file., %str(/), _)));
                %let g_src_list_&id.=&&&g_src_list_&id. &file.;
            %end;
        %let i=%eval(&i.+1);
        %let file=%scan(&files., &i., %str( ));
    %end;
    %let g_src_list_&id.=%sort(&&&g_src_list_&id.,uniq=1);
%exit:
    %let &_lst_.=&&&g_src_list_&id.;
%mend;