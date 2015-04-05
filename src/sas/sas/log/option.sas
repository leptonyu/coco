%import(assertref);

%macro sas_log_option(_opns_, _dopns_);
    %assertref(&_opns_.);
    %assertref(&_dopns_.);

    %if %length(&&&_opns_.)=0 %then
        %let &_opns_.=nonotes nosource nomprint nomlogic nosymbolgen;
    %local _i_ _opn_;
    %let _i_=1;
    %let _opn_=%scan(&&&_opns_., &_i_.);

    %do %while(%sysfunc(compress("&_opn_."))^="");
        %let &_dopns_.=&&&_dopns_. %sysfunc(getoption(&_opn_.));
        %let _i_=%eval(&_i_.+1);
        %let _opn_=%scan(&&&_opns_., &_i_.);
    %end;
    options &&&_opns_.;
%mend;