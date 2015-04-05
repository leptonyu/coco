%macro getpath(name);
    %local filename;
    %let filename=%sysfunc(tranwrd(&name., _, &g_.));
    %local src_dir;
    %let src_dir=&g_src.sas&g_.lang&g_.;

    %if %bquote(&filename.)=%bquote(&name.) and 
        %sysfunc(fileexist(&src_dir.&filename..sas)) %then
            %do;
            %let filename=sas&g_.lang&g_.&filename.;
        %end;
    &filename.
%mend;