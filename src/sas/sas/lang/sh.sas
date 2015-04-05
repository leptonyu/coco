%import(option);
%import(ref);

%macro sh/parmbuff;
    %local __option__ __temp__ __timestart__;
    %let __timestart__=%sysfunc(time());
    %option(__option__);
    %ref(__temp__);

    data _null_;
        length buff $32767;
        file &__temp__.;
        buff=symget("SYSPBUFF");
        put '%put "' buff '";';
    run;

    %option(__option__);

    %if %sysfunc(fexist(&__temp__.)) %then
        %do;
            %inc "%sysfunc(pathname(&__temp__.))";
        %end;
    %option(__option__);
    %ref(__temp__, clear);
    %option(__option__);
    %put NOTE: MACRO<&sysmacroname.> run %sysevalf(%sysfunc(time())-&__timestart__.)s.;
%mend;