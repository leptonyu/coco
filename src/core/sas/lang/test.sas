%import(getpath);
%import(asserteq);
%import(assertne);
%import(assertref);


%macro test(name);
    %if %length(&name.)=0 %then
        %do;
            %put ERROR: Please specify the test file name;
            %return;
        %end;

    %import(&name.);
    
    %local file;
    %let file=%getpath(&name., sufix=_test);

    %if %length(&file.)=0 %then
        %do;
            %put ERROR: MACRO<&name.> not exist!;
            %return;
        %end;
    %else %if not %sysfunc(fileexist(&file.)) %then
        %do;
            %put WARNING: MACRO<&name.> has not test!;
            %return;
        %end;
    %inc "&file.";
    %put NOTE: Test MACRO<&name.> OK;
%mend;