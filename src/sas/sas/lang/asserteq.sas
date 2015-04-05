%macro asserteq(expected, actual);
    %if %bquote("&expected.")^=%bquote("&actual.") %then
        %do;
            %put ERROR: Value "&actual." was excepted to be "&expected." ;
            %put _LOCAL_;
            %abort;
        %end;
%mend;