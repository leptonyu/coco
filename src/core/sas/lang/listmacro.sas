%import(ismacroref);
%import(sas_file_list);

%macro listmacro(_lst_, id=0);
    %local i ;

    %if "&id."="" %then
        %do;

            %do i=0 %to 9;
                %listmacro(&_lst_., id=&i.);
            %end;
            %return;
        %end;
    %local flag;
    %let flag=0;
    %if not %ismacroref(&_lst_.) %then
        %do;
            %let flag=1;
            %local lst;
            %let _lst_=lst;
        %end;
    %local src;

    %if "&id."="0" %then
        %do;
            %let src=&g_src.;
        %end;
    %else
        %do;

            %if not %symexist(g_src_&id.) %then
                %do;
                    %return;
                %end;
            %let src=&&&g_src_&id.;
        %end;
    %local files;
    %sas_file_list(&src., files, suffix=.sas);
    %local file c;
    %let i=1;
    %let c=1;
    %let file=%scan(&files., &i., %str( ));

    %do %while("&file."^="");

        %if not %hassuffix(&file., _test.sas) and "&file."^=".sas" %then
            %do;
                %let file=%substr(&file., 1, %length(&file.)-4);
                %let file=%canonicalname(%sysfunc(tranwrd(&file., %str(/), _)));

                %if &flag. %then
                    %do;
                        %put &c. &file.;
                        %let c=%eval(&c.+1);
                    %end;
                %else
                    %do;
                        %let &_lst_.=&&&_lst_. &file.;
                    %end;
            %end;
        %let i=%eval(&i.+1);
        %let file=%scan(&files., &i., %str( ));
    %end;
%mend;