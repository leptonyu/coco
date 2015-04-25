/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-09 09:32:34
 * @version 1.0
 * @desp print file on log
 *************************************************/

%import(ref);
%import(option);
%import(isfileref);

%macro print(file);
    %local flag option;
    %option(option);

    %if %isfileref(&file.) %then
        %do;
            %let flag=0;
        %end;
    %else %if %sysfunc(fileexist(&file.)) %then
        %do;
            %let flag=1;
        %end;
    %else
        %do;
            %let file=%getpath(&file.);

            %if "&file."="" %then
                %goto exit;
            %let flag=1;
        %end;

    %if &flag.=1 %then
        %do;
            %ref(file);
        %end;

    %if &file.^=__err %then
        %do;
            data _null_;
                infile &file.;
                input;
                put _infile_;
            run;

        %end;

    %if &flag.=1 %then
        %do;
            %ref(file, clear);
        %end;
%exit:
    %option(option);
%mend;