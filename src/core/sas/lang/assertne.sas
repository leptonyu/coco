%macro assertne(expected, actual);
    %if %bquote("&expected.")=%bquote("&actual.") %then
        %do;
            %put ERROR: Value "&actual." was NOT excepted to be "&expected." ;
            %put _LOCAL_;
            %abort;
        %end;
    %put NOTE: <&expected.> NOT equals <&actual.>!;
%mend;