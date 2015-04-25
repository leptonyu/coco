/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-09 09:32:34
 * @version 1.0
 *
 *************************************************/

%import(sas_set_name);
%import(sas_lib_name);
%import(validate);

%macro sas_set_index(fin, _index_);
    %if not %validate(&_index_.,fin lib name) %then %return;
    
    %let name=%sas_set_name(&fin.);

    %if "&name."="" %then
        %do;
            %put WARN: Dataset<&fin.> is not valid!;
            %return;
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
%mend;