%macro assertref(_refname_);
    %if %sysfunc(compress("&_refname_."))="" %then
        %do;
            %put ERROR: Empty parameter!;
            %abort;
        %end;
    %else %if not %symexist(&_refname_.) %then
        %do;
            %put ERROR: &_refname_. is NOT macro variable!;
            %abort;
        %end;
%mend;