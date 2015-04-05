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

    /* step 1 set g_src*/
    
    %if not %symexist(g_src) %then
        %do;
            %put ERROR: Global macro g_src not found!;
            %abort;
        %end;

    /* if exists then return */
    
    
    %if %sysmacexec(&name.) %then
        %return;

    /* step 2 prepare sub macros.*/
    %local imports i imps;
    %let imports=asserteq assertne canoicalname getpath;
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
    %let name=%canoicalname(&name.);
    %local filename path;
    %let filename=%getpath(&name.);
    %let path=&g_src.&filename..sas;

    /* step 4 find source file in default src path. */
    
    
    %if %sysfunc(fileexist(&path.)) %then
        %do;
            %inc "&path.";
            %return;
        %end;

    /* step 5 find source file in extended src path.*/
    %local src_dir;

    %if %index(&filename., sas)^=1 %then
        %do i=1 %to 9;

            %if %symexist(g_src_&i.) %then
                %do;
                    %let src_dir=&&g_src_&i.;
                    %let src_dir=&src_dir.&filename..sas;

                    %if %sysfunc(fileexist(&src_dir.)) %then
                        %do;
                            %inc "&src_dir.";
                            %return;
                        %end;
                %end;
        %end;

    /* throw exception*/
    %put ERROR: MARCO &name. not found!;
    %abort;
%mend;