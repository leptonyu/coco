/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(ref);

%macro print(file) ;
    %ref(file);

    %if &file.^=__err %then
        %do;

            data _null_;
                infile &file.;
                input;
                put _infile_;
            run;

        %end;
    %ref(file, clear);
%mend;