/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(ismacroref);
%import(canonicalname);
%import(getpath);
%import(listmacro);
%import(asserteq);
%import(assertne);
%import(assertref);
%import(hasprefix);

%macro test(name, _check_);
    %if not %ismacroref(&_check_.) %then
        %do;
            %local check;
            %let _check_=check;
        %end;
    %local __timestart__;
    %let __timestart__=%sysfunc(time());

    %if "%lowcase(&name.)"="_all_" %then
        %do;
            %local allmacro;
            %listmacro(allmacro);
            %local i item;
            %let i=1;
            %let item=%scan(&allmacro., &i., %str( ));

            %do %while("&item."^="");
                %local re;
                %test(&item., re);

                %if "&&&_check_."^="0" %then
                    %do;
                        %let &_check_.=&re.;
                    %end;
                %let i=%eval(&i.+1);
                %let item=%scan(&allmacro., &i., %str( ));
            %end;
            %goto exit;
        %end;
    %let &_check_.=0;
    %local sname;
    %let sname=&name.;
    %let name=%canonicalname(&name.);

    %if %length(&name.)=0 %then
        %do;
            %put WARNING: <&sname.> is invalid, 
                please specify a valid macro name;
            %return;
        %end;
    %put NOTE: Testing MACRO<&name.>...;
    %import(&name.);
    %local file;
    %let file=%getpath(&name., suffix=_test);

    %if %length(&file.)=0 %then
        %do;
            %put WARNING: MACRO<&name.> not exist!;
            %return;
        %end;
    %else %if not %sysfunc(fileexist(&file.)) %then
        %do;
            %put WARNING: MACRO<&name.> has not test!;
            %return;
        %end;
    %inc "&file.";
    %let &_check_.=1;
%exit:
    %put NOTE: Test MACRO<&name.> OK%str(,) cost %sysevalf(%sysfunc(time())-&__timestart__.)s.;
%mend;