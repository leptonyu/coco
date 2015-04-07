%import(ismacroref);

%macro dep(name, _list_);
    %local import_names;
    %import(&name.);
    %if %ismacroref(&_list_.) %then
        %do;
            %let &_list_.=&import_names.;
        %end;
    %else
        %do;
            %put &import_names;
        %end;
%mend;