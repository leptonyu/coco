/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-24 23:30:06
 * @version 1.0
 * @desp    get help of macro
 *************************************************/

%import(canonicalname);
%import(getpath);
%import(option);
%import(dep);
%import(listmacro);
%import(sort);

%macro help(name);
    %local option;
    %option(option);
    %let name=%canonicalname(&name.);

    %if "&name."="" %then
        %do;
        %local list;
        %listmacro(list);
        data _null_;
          length line $128 total 8;
          total=78;
          line='+'||repeat('-',total)||'+';
          put line @3 'LIST coco Macros';
          line='|'||repeat(' ',total)||'|';
          %local i v;
          %let i=1;
          %let v=%scan(&list.,&i.,%str( ));
          %do %while("&v"^="");
            put line @3 "&i." @14 "&v.";
            %let i=%eval(&i.+1);
            %let v=%scan(&list.,&i.,%str( ));
          %end;
          line='+'||repeat('-',total)||'+';
          put line @(total-16) 'Designed by Daniel';
        run;
            %goto exit;
        %end;
    %local path;
    %let path=%getpath(&name.);
    
    %local list;
    %dep(&name.,list);
    %let list=%sort(&list.,uniq=1);

    data _null_;
        length stoken 8 etoken 8 itoken 8 state 8 name $32 line $128 total 8
            value $512;
        infile "&path." end=eof;
        input;

        if _n_=1 then
            do;
                stoken=prxparse('/^\/\*+\s*$/i');
                etoken=prxparse('/^\s*\*+\/\s*$/i');
                itoken=prxparse('/\s*\*?\s*@([a-z][0-9a-z]*)\s+(.*?)\s*$/i');
                state=0;
                total=78;
                line='+'||repeat('-',total)||'+';
                put line @3 "HELP &name.";
                line='|'||repeat(' ',total)||'|';
                put line @3 'name' @14 "&name.";
                line='|'||repeat(' ',total)||'|';
                put line @3 'path' @14 "&path.";
                %if "&list."^="" %then %do;
                  %local i v y;
                  %let i=1;
                  %let v=%scan(&list.,&i.,%str( ));
                  %let y=%scan(&list.,%eval(&i.+1),%str( ));
                  %do %while("&v."^="");
                    %if &i.=1 %then %do;
                        put line @3 'dep' @14 "&v." @47 "&y. ";
                    %end;%else %do;
                        put line @14 "&v." @47 "&y. ";
                    %end;
                    %let i=%eval(&i.+2);
                    %let v=%scan(&list.,&i.,%str( ));
                    %let y=%scan(&list.,%eval(&i.+1),%str( ));
                  %end;
                %end;
                line='+'||repeat('-',total)||'+';
                put line;
            end;

        if prxmatch(stoken, _infile_) then
            do;
                state+1;
            end;
        else if prxmatch(etoken, _infile_) then
            do;
                state=state-1;
                goto stop;
            end;
        else if state>0 and prxmatch(itoken, _infile_) then
            do;
                name=prxposn(itoken, 1, _infile_);
                value=prxposn(itoken, 2, _infile_);
                line='|'||repeat(' ',total)||'|';
                put line @3 name @14 value ;
            end;
        retain stoken etoken itoken state total;
        if eof then goto stop ;
        return;
stop:
                line='+'||repeat('-',total)||'+';
                put line @(total-16) 'Designed by Daniel';
        stop;
    run;
%exit:
    %option(option);
%mend;
