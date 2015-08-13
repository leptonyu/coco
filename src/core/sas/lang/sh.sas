/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-09 09:32:34
 * @version 1.0
 * @desp    shell for coco macros
 *************************************************/

%import(option);
%import(ref);
%import(print);
%import(sort);
%import(canonicalname);
%import(getpath);
%import(sas_str_unregister);
%import(sas_str_gc);
%import(sas_list_new);

%macro sh/parmbuff;
    %local __option__ __temp__ __timestart__;
    %let __timestart__=%sysfunc(time());
    %option(__option__);
    %ref(__temp__);

    %if %symexist(g_sh) %then
        %do;
            %let g_sh=%eval(&g_sh.+1);
        %end;
    %else
        %do;
            %global g_sh;
            %let g_sh=1;
        %end;

    %if not %symexist(g_sh_last) %then
        %do;
            %global g_sh_last;
        %end;
    %local g_sh_pool_&g_sh.;
    %let g_sh_pool_&g_sh.=|;

    data _null_;
        length buff $32767 token 8 item $4096 px $4096 com 3 ig $1024 name $32 
            imports $4096 retrn $32;
        array stack{20} $1024;
        array method{16} $1024;
        file &__temp__.;
        err=0;
        px='/\/\*|\*\/';
        px=trim(px)||'|[(){};"'||"'"||']';
        px=trim(px)||'|(\$|[_a-z][_0-9a-z]*)\s*=';
        px=trim(px)||'|[_a-z][_0-9a-z]*(\.[_a-z][_0-9a-z]*)?';
        px=trim(px)||'|\[[^,]*?(,[^,]+)*?\]';
        px=trim(px)||'/i';
        token=prxparse(px);
        listtoken=prxparse('/\[[^,]*(,[^,]+)*\]/');
        igtoken=prxparse("/^(%?\*|\'|%.*:)/");
        mtoken=prxparse('/^[_a-z][_0-9a-z]*(\.[_a-z][_0-9a-z]*)?$/i');
        lettoken=prxparse('/^([_a-z][_0-9a-z]*|\$)\s*=$/i');
        shtoken=prxparse('/^\s*\(.*\)\s*$/i');
        buff=prxchange('s/^\((.*)\)\s*$/$1;/', 1, symget("SYSPBUFF"));

        if compress(buff)='' then
            stop;
        retrn='g__';
        com=0;
        sq=0;
        mq=0;
        bq=0;
        sqstart=-1;
        mqstart=-1;
        bqstart=-1;
        id=0;
        mid=0;
        bigstatus=0;
        imports='|';
        starttoken=prxparse('/^[{]$/');
        stoptoken=prxparse('/^[};]$/');
        start=1;
        stop=length(trim(buff));
        call prxnext(token, start, stop, buff, pos, len);
        last=1;
        put '%macro ' "_sh_&g_sh." '();';
        put '    %local ' retrn +(-1) ';';
        put '    %let g_sh_last=;';

        do while(pos>0);

            if sq=0 and mq=0 and bq=0 and pos>last then
                do;
                    ig=substr(buff, last, pos-last);

                    if compress(ig)^='' then
                        do;
                            put 'ERROR: Unknown token ' ig;
                            err=1;
                            goto stop;
                        end;
                end;
            last=pos+len;
            item=substr(buff, pos, len);

            if item="*/" then
                do;
                    com=0;
                    goto cont;
                end;

            if item="/*" then
                do;
                    com=1;
                    goto cont;
                end;

            if item='"' and mq=0 and bq=0 then
                do;
                    sq=ifn(sq, 0, 1);

                    if sq=1 then
                        do;
                            mqstart=pos;
                        end;
                    else
                        do;
                            item=substr(buff, mqstart, pos-mqstart+1);
                            goto word;
                        end;
                    goto cont;
                end;

            if item="'" and sq=0 and bq=0 then
                do;
                    mq=ifn(mq, 0, 1);

                    if mq=1 then
                        do;
                            sqstart=pos;
                        end;
                    else
                        do;
                            item=substr(buff, sqstart, pos-sqstart+1);
                            goto word;
                        end;
                    goto cont;
                end;

            if item='(' and mq=0 and sq=0 then
                do;
                    bq+1;

                    if bq=1 then
                        do;
                            bqstart=pos;
                            item=';';
                            goto word;
                        end;
                    goto cont;
                end;

            if item=')' and mq=0 and sq=0 then
                do;
                    bq=bq-1;

                    if bq=0 then
                        do;
                            item=substr(buff, bqstart, pos-bqstart+1);
                            put '    %sh' item +(-1) ';';
                            put '    %let ' retrn +(-1) '=&g_sh_last.;';
                            item=';';
                            goto word;
                        end;
                    goto cont;
                end;

            if com=1 or sq=1 or mq=1 or bq>0 then
                goto cont;

            if prxmatch(igtoken, trim(item)) then
                goto cont;

            if item='{' then
                bigstatus+1;

            if item='}' then
                bigstatus=bigstatus-1;
word:

            /* method stack */
            if prxmatch(starttoken, trim(item)) then
                do;
                    id+1;
                    stack[id]=item;
                    goto method;
                end;
            else if prxmatch(stoptoken, trim(item)) then
                do;

                    if item='}' and (id=0 or stack[id]^='{') then
                        do;
                            put 'ERROR: Uncomplete {}';
                            err=1;
                            goto stop;
                        end;

                    if id>0 then
                        do;

                            if compress(stack[id]||item)='{}' then
                                do;
                                    stack[id]='';
                                    id=id-1;
                                end;
                        end;
method:

                    if mid<=0 then
                        goto cont;

                    if prxmatch(mtoken, trim(method[1])) then
                        do;
                            name=resolve('%canonicalname('||method[1]||')');

                            if name='' then
                                do;
                                    put 'ERROR: cannot resolve macro ' 
                                        method[1];
                                    err=1;
                                    goto stop;
                                end;

                            if name='put' then
                                do;
                                    put '    %put ' @;

                                    do i=2 to mid;
                                        method[i]=dequote(method[i]);
                                        method[i]=prxchange('s/([";'||"'"||'])/%str(%$1)/', 
                                            -1, method[i]);
                                        put method[i] @;
                                    end;
                                    put  +(-1) ';';
                                    goto endmethod;
                                end;
                            else if resolve('%getpath('||trim(name)||')')='' 
                                then
                                    do;
                                    put 'ERROR: Macro ' name 'not exist!';
                                    err=1;
                                    goto stop;
                                end;

                            if not index(imports, '|'||trim(name)||'|') then
                                do;
                                    imports='|'||trim(name)||imports;
                                end;

                            if bigstatus or item='}' then
                                do;
                                    put '    %let ' retrn +(-1) '=%' name +(-1) 
                                        '(' @;
                                end;
                            else
                                do;
                                    put '    %' name +(-1) '(' @;
                                end;

                            do i=2 to mid;

                                if i>2 then
                                    put ',' @;
                                method[i]=dequote(method[i]);
                                method[i]=prxchange('s/([";'||"'"||'])/%str(%$1)/', 
                                    -1, method[i]);
                                put method[i] +(-1) @;
                            end;
                            put ');';

                            if bigstatus or item='}' then
                                do;
                                    put '    %put &' retrn +(-1) '.;';
                                end;
endmethod:
                        end;
                    else if prxmatch(lettoken, trim(method[1])) then
                        do;
                            name=trim(retrn)||compress(method[1], ' =$');
                            call symputx(name, '', 'LOCAL');
                            put '    %let ' name +(-1) '=' @;

                            do i=2 to mid;

                                if prxmatch(listtoken, trim(method[i])) then
                                    do;

                                        if i^=2 and mid^=2 then
                                            do;
                                                put 'ERROR: Unkown token ' 
                                                    method[*];
                                                err=1;
                                                goto stop;
                                            end;
                                        put '%sas_list_new(' method[i] +(-1) ')' @;
                                    end;
                                else
                                    do;
                                        method[i]=dequote(method[i]);
                                        method[i]=prxchange('s/([";'||"'"||'])/%str(%$1)/', 
                                            -1, method[i]);
                                        put method[i] +(-1) @;
                                    end;
                            end;
                            put ';';
                        end;
                    else
                        do;
                            put 'ERROR: Unknown token ' method[1];
                            err=1;
                            goto stop;
                        end;
                    mid=0;
                    goto cont;
                end;
            mid+1;

            if mid=1 then
                do;

                    if not prxmatch(mtoken, trim(item)) and not 
                        prxmatch(lettoken, trim(item)) and not 
                        prxmatch(listtoken, trim(item)) then
                            do;
                            put 'ERROR: Unknown method ' item;
                            err=1;
                            goto stop;
                        end;
                end;
            else
                do;

                    if index(item, '"')=1 then
                        do;
                            item=tranwrd(item, '$', '&'||trim(retrn));
                            item=tranwrd(item, '#', trim(retrn));
                        end;
                end;
            method[mid]=item;
cont:
            call prxnext(token, start, stop, buff, pos, len);
        end;

        if last^=-1 and stop>last then
            do;
                ig=substr(buff, last, stop-last);

                if compress(ig)^='' then
                    do;
                        put 'ERROR: Unknown token ' ig;
                        err=1;
                        goto stop;
                    end;
            end;

        if id then
            do;
                put 'ERROR: Stack uncomplete ' @;

                do i=1 to id;
                    put stack[id]=@;
                end;
                put ' ';
                err=1;
                goto stop;
            end;

        if bq then
            do;
                put 'ERROR: Uncomplete ()';
                err=1;
                goto stop;
            end;

        if mid then
            do;
                put 'ERROR: executed method ' @;

                do i=1 to mid;
                    put method[mid]=@;
                end;
                put ' ';
                err=1;
                goto stop;
            end;

        if mq or sq then
            do;
                put 'ERROR: Uncomplete string';
                err=1;
                put _all_;
                goto stop;
            end;
stop:

        if err then
            do;
                call symputx('SYSRC', '1');
            end;
        else
            do;
                put '    %let g_sh_last=&' retrn +(-1) '.;';
                put '%mend;';
                i=1;
                name=scan(imports, i, '|');

                do while(name^='');
                    put '%import(' name +(-1) ');';
                    i+1;
                    name=scan(imports, i, '|');
                end;
                put '%' "_sh_&g_sh." '();';
                put '%sysmacdelete' " _sh_&g_sh.;";
            end;
    run;

    %if &sysrc. %then
        %do;
            %put ERROR: Script parse error;

            %if %sysfunc(fexist(&__temp__.)) %then
                %do;
                    %print(%sysfunc(pathname(&__temp__.)));
                %end;
            %goto exit;
        %end;

    %if not %sysfunc(fexist(&__temp__.)) %then
        %goto exit;

    %if %symexist(g_sh_openlog) %then
        %do;

            %if "&g_sh_openlog."="1" %then
                %do;
                    %put --- SH(&g_sh.): AUTO CREATED CODE >>> SOURCE ---;
                    %put &SYSPBUFF.;
                    %put --- SH(&g_sh.): AUTO CREATED CODE >>> START ---;
                    %print(%sysfunc(pathname(&__temp__.)));
                    %put --- SH(&g_sh.): AUTO CREATED CODE <<< END   ---;
                %end;
        %end;
    %option(__option__);
    %inc "%sysfunc(pathname(&__temp__.))";
    %option(__option__);

    %if "&&&g_sh_pool_&g_sh"^="|" %then
        %do;
            %sas_str_unregister(&&&g_sh_pool_&g_sh..);
            %sas_str_gc();
        %end;
    %else %if &g_sh.=1 %then
        %do;
            %sas_str_gc();
        %end;
%exit:
    %ref(__temp__, clear);
    %option(__option__);
    %put NOTE: MACRO<&sysmacroname.(&g_sh.)> run %trim(%sysfunc(abs(%sysevalf(%sysfunc(time())-&__timestart__.)), 
        10.3))s.;
    %let g_sh=%eval(&g_sh.-1);
%mend;