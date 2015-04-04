/**
use as the fundamental macro of this lib.
this macro can smart import sas macro files.
@author Daniel YU
@since 2015-03-05
@version 1.0
*/
%macro import(name);
    * check self execute;
    %let name=%sysfunc(compress(%lowcase(&name.)));

    %if %BQUOTE(&name.)=import %then
        %return;
    * check dup 1 step;

    %if not %symexist(mcrname) %then
        %do;
            %local mcrname;
            %let mcrname=|&name.|;
        %end;
    %else %if not %index(&mcrname., |&name.|) %then
        %do;

            %if not %index(&name., _) or not %index(&mcrname., 
                %sysfunc(tranwrd(&name.|, %scan(&name., -1, _)|, *))) %then
                    %let mcrname=&mcrname.&name.|;
            %else
                %return;
        %end;
    %else
        %return;
    *check dup 2 step;

    %if %sysfunc(cexist(work.sasmacro.&name..macro)) %then
        %return;
    * load macro;
    %local origin_name;
    %let origin_name=&name.;

    %if %index(&name., _)>1 %then
        %let name=%sysfunc(tranwrd(&name., _, &g_.));
    %else %if  %sysfunc(fileexist(&g_src.sas&g_.lang&g_.&name..sas)) %then
        %let name=sas&g_.lang&g_.&name.;
    %let name=&name..sas;
    %local file;
    %let file=&g_src.&name.;

    %if %sysfunc(fileexist(&file.)) %then
        %do;
            %inc "&file.";
        %end;
    %else
        %do;
            %put ERROR: macro &origin_name. NOT Found;
            %abort;
        %end;
%mend;