%macro sas_file_delete(file);
    %if %length(&file.) %then
        %do;
            %local delete;
            %let delete=delete;
            %let sysrc=%sysfunc(filename(delete, &file.));

            %if &sysrc.=0 and %sysfunc(fexist(&delete.)) %then
                %do;
                    %let sysrc=%sysfunc(fdelete(&delete.));
                %end;
            %else
                %put NOTE: File &file. not exist!;
            %let sysrc=%sysfunc(filename(&delete.));
        %end;
    %else
        %do;
            %put WARNING: &sysmacroname. must have parameter file!;
        %end;
%mend;