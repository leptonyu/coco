%macro option(_option_, mdfopns);
    %if %length(&_option_.)=0 %then
        %return;
    %else %if not %symexist(&_option_.) %then
        %return;

    %if %length(&&&_option_.) %then
        %do;
            options &&&_option_.;
            %let &_option_.=%str();
        %end;
    %else
        %do;

            %if %length(&mdfopns.)=0 %then
                %let mdfopns=nonotes nosource nomprint nomlogic nosymbolgen compress=yes;
            %local mdfopn i;
            %let i=1;
            %let mdfopn=%qscan(&mdfopns., &i.);

            %do %while(%length(&mdfopn.));

                %if not %index(&mdfopn., =) %then
                    %let &_option_.=&&&_option_. %sysfunc(getoption(&mdfopn.));
                %else
                    %let &_option_.=&&&_option_. %qscan(&mdfopn., 1, 
                        =)=%sysfunc(getoption(%qscan(%bquote(&mdfopn.), 1, =)));
                %let i=%eval(&i.+1);
                %let mdfopn=%qscan(&mdfopns., &i.);
            %end;
            options &mdfopns.;
        %end;
%mend;