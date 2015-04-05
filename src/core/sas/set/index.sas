%macro sas_set_index(fin, _index_);
    %local lib;

    %if not %index(&fin., .) %then
        %let lib=work;
    %else
        %do;
            %let lib=%upcase(%scan(&fin., 1, .));
            %let fin=%scan(&fin., 2, .);
        %end;

    %if %sysfunc(exist(&lib..&fin.)) %then
        %do;

            proc sql noprint;
                select compress(indxname||'|'||name) into :&_index_. separated 
                    by ' ' from sashelp.vindex where libname="&lib." and 
                    memname=upcase("&fin.") and idxusage="simple";
            quit;

        %end;
    %else
        %let &_index_.=1;

    %if not %index(&&&_index_., |) %then
        %let &_index_.=1;
%mend;