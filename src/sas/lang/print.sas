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