%macro getpath(filename, sufix=);
    %let filename=%canonicalname(&filename.);
    %if %length(&filename.)=0 %then
        %return;

    %if not %symexist(g_src) %then
        %do;
            %put ERROR: Global macro g_src not found!;
            %abort;
        %end;
    %local name path;
    %let name=&filename.;
    %let filename=%sysfunc(tranwrd(&filename., _, &g_.));
    %let path=&g_src.sas&g_.lang&g_.;

    %if %bquote(&filename.)=%bquote(&name.) and 
        %sysfunc(fileexist(&path.&filename..sas)) %then
            %do;
            %let filename=sas&g_.lang&g_.&filename.;
        %end;
    %let path=&g_src.&filename..sas;

    %if %sysfunc(fileexist(&path.)) %then
        %do;
            %let path=&g_src.&filename.&sufix..sas;
            &path.
            %return;
        %end;

    /* find source file in extended src path.*/ 

    %local i;
    %if %index(&filename., sas)^=1 %then
        %do i=1 %to 9;
            %if %symexist(g_src_&i.) %then
                %do;
                    %let path=&&g_src_&i.;
                    %let path=&path.&filename.;
                    %if %sysfunc(fileexist(&path..sas)) %then
                        %do;
                            %let path=&path.&sufix..sas;
                            &path.
                            %return;
                        %end;
                %end;
        %end;
%mend;