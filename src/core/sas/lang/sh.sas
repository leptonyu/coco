/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

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