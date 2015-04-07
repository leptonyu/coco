%import(ismacroref);
%import(canonicalname);
%import(getpath);
%import(asserteq);
%import(assertne);
%import(assertref);

%macro test(name, _check_);
    %if not %ismacroref(&_check_.) %then
        %do;
            %local check;
            %let _check_=check;
        %end;
    %let &_check_.=0;
    %local sname;
    %let sname=&name.;
    %let name=%canonicalname(&name.);

    %if %length(&name.)=0 %then
        %do;
            %put WARNING: <&sname.> is invalid, please specify a valid macro name;
            %return;
        %end;
    %put NOTE: Testing MACRO<&name.>...;
    
    %import(&name.);
    
    %local file;
    %let file=%getpath(&name., sufix=_test);

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
    %local __timestart__;
    %let __timestart__=%sysfunc(time());
    %inc "&file.";
    %let &_check_.=1;
    %put NOTE: Test MACRO<&name.> OK, cost %sysevalf(%sysfunc(time())-&__timestart__.)s.;
%mend;