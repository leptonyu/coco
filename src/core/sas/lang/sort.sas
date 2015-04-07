%macro sort(list, uniq=0);
    %if %length(&list.)=0 %then
        %do;
            %return;
        %end;
    %local i item ps;
    %let i=1;
    %let item=%scan(&list., &i., %str( ));

    %do %while("&item."^="");
        %local item_&i.;
        %let item_&i.=&item.;

        %if &i.=1 %then
            %do;
                %let ps=item_&i.;
            %end;
        %else
            %do;
                %let ps=&ps., item_&i.;
            %end;
        %let i=%eval(&i.+1);
        %let item=%scan(&list., &i., %str( ));
    %end;
    %syscall sortc(&ps.);
    %local re;

    %if "&uniq."="1" %then
        %do;
            %local last now;

            %do i=1 %to %eval(&i.-1);
                %let now=&&&item_&i.;

                %if "&last."^="&now." %then
                    %do;
                        %let re=&re. &now.;
                        %let last=&now.;
                    %end;
            %end;
        %end;
    %else
        %do i=1 %to %eval(&i.-1);
            %let re=&re. &&&item_&i.;
        %end;
    &re.
%mend;