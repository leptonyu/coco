/**
use as the fundamental macro of this lib.
this macro can smart import sas macro files.
@author Daniel YU
@since 2015-03-05
@version 1.0
*/
%macro import(name);
    %let name=%canonicalname(&name.);

    %if %length(&name.)=0 %then
        %return;
    %* This step use to collect depedencies;

    %if %symexist(import_names) %then
        %do;
            %if %index(&import_names., |&name.|) %then
                %return;
            %let import_names=&import_names.&name.|;
        %end;
    %else
        %do;
            %local import_names;
            %let import_names=|&name.|;
        %end;

    %if %sysmacexec(&name.) %then
        %return;
    %local path;
    %let path=%getpath(&name.);

    %if %length(&path.) %then
        %do;
            %inc "&path.";
        %end;
    %else
        %do;
            %put ERROR: MARCO &name. not found!;
            %abort;
        %end;
%mend;