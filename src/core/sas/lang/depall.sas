/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-26 03:49:00
 * @version 1.0
 * @desp    get all dependencies.
 *************************************************/

%import(dep);
%import(ismacroref);
%import(sas_str_contain);

%macro depall(name, _list_);
    %if not %ismacroref(&_list_.) %then %do;
      %put WARNING: parameter error;
    %end;
    %local all final;
    %dep(&name., all);
    %local i v;
    %let i=1;
    %let v=%scan(&all., &i., %str( ));
    %do %while("&v."^="");
        %if not %sas_str_contain(&final.,&v.) %then %do;
          %let final=&final. &v.;
          %local temp;
          %dep(&v.,temp);
          %let all=&all. &temp.;
        %end;
        %let i=%eval(&i.+1);
        %let v=%scan(&all., &i., %str( ));
    %end;
    %let &_list_.=&final.;
%mend;
