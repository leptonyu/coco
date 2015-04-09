/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(canonicalname);
%import(getpath);

%macro newmacro(name, srcid=);
    %if "&srcid."="" %then
        %do;

            %if not %symexist(g_curr) %then
                %do;
                    %put ERROR: Source Folder not specified!;
                    %return;
                %end;
            %else
                %do;
                    %let srcid=&g_curr;
                %end;
        %end;
    %local fname;
    %let fname=%canonicalname(&name.);

    %if "&fname."="" %then
        %do;
            %put ERROR: Specified macro name <&name.> is invalid!;
            %return;
        %end;
    %local path;
    %let path=%getpath(&fname., srcid=&srcid.);

    %if "&path"="" %then
        %do;
            %put ERROR: Source Folder not specified!;
            %goto testfile;
        %end;
    %else %if %sysfunc(fileexist(&path.)) %then
        %do;
            %put NOTE: Macro<&fname.> has already existed!;
            %goto testfile;
        %end;
        
    %local author;
    %let author=Daniel YU;

    data _null_;
        file "&path.";
        year=put(year(date()), 4.);
        date=put(date(), yymmdd10.);
        time=put(time(), tod8.);
        put '/*************************************************';
        put '* Copyright(c) ' year 'coco, All Rights Reserved.';
        put "* @author  &author.";
        put '* @since   ' date time;
        put '* @version 1.0';
        put "* ";
        put '*************************************************/';
        put ' ';
        put '%macro ' "&fname.();";
        put ' %* Please write code here;;';
        put '%mend;';
        stop;
    run;

%testfile:
    %let path=%getpath(&fname., suffix=_test, srcid=&srcid.);

    %if "&path"="" %then
        %do;
            %put ERROR: Source Folder not specified!;
            %return;
        %end;
    %else %if %sysfunc(fileexist(&path.)) %then
        %do;
            %put NOTE: Macro<&fname.> test has already existed!;
            %return;
        %end;

    data _null_;
        file "&path.";
        put "%*Please write test code here;;";
        put '%*%asserteq( ,%' "&fname.());";
        put '%*%assertne( ,%' "&fname.());";
        put '%*%assertref( );';
    run;

%mend;