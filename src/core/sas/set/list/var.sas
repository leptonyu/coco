/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro sas_set_list_var(fin, _list_);
    %local _l_;

    %if %length(&_list_.)=0 %then
        %let _list_=_l_;
    %else %if not %symexist(&_list_.) %then
        %let _list_=_l_;
    %local lib;

    %if %index(&fin., .) %then
        %do;
            %let lib=%scan(&fin., 1, .);
            %let fin=%scan(&fin., 2, .);
        %end;
    %else
        %let lib=work;

    %if %sysfunc(exist(&lib..&fin.)) %then
        %do;

            proc sql noprint;
                select name into :&_list_. separated by ' '
			from sashelp.vcolumn
			where libname=upcase("&lib.") and memname=upcase("&fin.");
            quit;

        %end;
    %else
        %do;
            %let &_list_.=1;
        %end;

    %if &_list_.=_l_ %then
        %put &&&_list_.;
%mend;