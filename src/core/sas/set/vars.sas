/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-24 22:38:13
* @version 1.0
* 
*************************************************/
 
%import(sas_set_name);
%import(sas_lib_name);
%import(validate);

%macro sas_set_vars(fin,_vars_);
    %if not %validate(&_vars_.,fin lib name) %then %return;
    %local lib name;
    %let name=%sas_set_name(&fin.);

    %if "&name."="" %then
        %do;
            %put WARN: Dataset<&fin.> is not valid!;
            %return;
        %end;
    %let lib=%sas_lib_name(&fin.);

    %if %sysfunc(exist(&lib..&name.)) and %ismacroref(&_vars_.) %then
        %do;
            proc sql noprint;
                select name into :&_vars_. separated 
                    by ' ' from sashelp.vcolumn where lowcase(libname)="&lib."
                    and lowcase(memname)="&name.";
            quit;

        %end;
%mend;
