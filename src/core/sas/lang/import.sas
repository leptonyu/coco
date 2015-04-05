/**
use as the fundamental macro of this lib.
this macro can smart import sas macro files.
@author Daniel YU
@since 2015-03-05
@version 1.0
*/
%macro import(name);
    %let name=%lowcase(&name.);

    %if %length(&name.)=0 %then
        %return;

    %if %sysmacexec(&name.) %then
        %return;

    /* step 2 prepare sub macros.*/
    %local imports i imps;
    %let imports=canonicalname getpath;
    %let i=1;
    %let imps=%scan(&imports., &i., %str( ));

    %do %while(%sysfunc(compress("&imps."))^="");
        %if not %sysmacexist(&imps.) %then
            %do;
                %inc "&g_src.sas&g_.lang&g_.&imps..sas";
            %end;
        %let i=%eval(&i.+1);
        %let imps=%scan(&imports., &i., %str( ));
    %end;

    /*step 3 format the name */
    %let name=%canonicalname(&name.);
    %local  path;
    %let path=%getpath(&name.);

    %if %length(&path.) %then
        %do;
            %inc "&path.";
        %end;
    %else
        %do;

            /* throw exception*/
    %put ERROR: MARCO &name. not found!;
            %abort;
        %end;
%mend;