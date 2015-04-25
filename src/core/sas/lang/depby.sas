/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-25 13:28:14
 * @version 1.0
 *
 *************************************************/

%import(dep);
%import(option);
%import(listmacro);
%import(ismacroref);
%import(canonicalname);
%import(sas_str_contain);

%macro depby(name, _list_);
    %local option;
    %option(option);
    %let name=%canonicalname(&name.);
    %if "&name."="" %then
        %goto exit;
    %local allmacros;
    %listmacro(allmacros);
    %local i mm macrolist;
    %let i=1;
    %let mm=%scan(&allmacros., &i., %str( ));

    %do %while("&mm."^="");
        %local dep;
        %dep(&mm., dep);
        %if %sas_str_contain(&dep., &name.) %then
            %do;
                %let macrolist=&macrolist. &mm.;
            %end;
        %let i=%eval(&i.+1);
        %let mm=%scan(&allmacros., &i., %str( ));
    %end;

    %if %ismacroref(&_list_.) %then
        %do;
            %let &_list_.=&macrolist.;
        %end;
    %else
        %put &macrolist.;
%exit:
    %option(option);
%mend;