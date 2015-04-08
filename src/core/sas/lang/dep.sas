%import(ismacroref);

%macro dep(name, _list_);
    %local import_names;
    %import(&name.);
    %local ps;
    %local i item;
    %let i=1;
    %let item=%scan(&import_names., &i., %str(|));

    %do %while("&item."^="");
        %let ps=&ps. &item.;
        %let i=%eval(&i.+1);
        %let item=%scan(&import_names., &i., %str(|));
    %end;

    %if %ismacroref(&_list_.) %then
        %do;
            %let &_list_.=&ps.;
        %end;
    %else
        %do;
            %put &ps;
        %end;
%mend;