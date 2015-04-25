/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-09 09:32:34
 * @version 1.0
 *
 *************************************************/

%import(sas_set_name);
%import(sas_lib_name);
%import(ismacroref);

%macro sas_set_index(fin, _index_);
    %local lib name;
    %let name=%sas_set_name(&fin.);

    %if "&name."="" %then
        %do;
            %put WARN: Dataset<&fin.> is not valid!;
            %return;
        %end;

    %if not %ismacroref(&_index_.) %then
        %do;
            %local index;
            %let _index_=index;
        %end;
    %let lib=%sas_lib_name(&fin.);

    %if %sysfunc(exist(&lib..&name.)) %then
        %do;
            proc sql noprint;
                select name into :&_index_. separated 
                    by ' ' from sashelp.vindex where lowcase(libname)="&lib."
                    and lowcase(memname)="&name.";
            quit;

        %end;
    %put NOTE: Dataset<&lib..&name.> index is &&&_index_.;
%mend;