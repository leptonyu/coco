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

%macro sh/parmbuff;
    %local __option__ __temp__ __timestart__ __g__;
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

    data _null_;
        length buff $32767 token 8 item $4096 px $4096 com 3 ig $1024 name $32;
        array stack{20} $1024;
        array method{16} $1024;
        file &__temp__.;
        err=0;
        px='/\/\*|\*\/';
        px=trim(px)||'|[(){};"'||"'"||']';
        px=trim(px)||'|[_a-z][_0-9a-z]*\s*=';
        px=trim(px)||'|[_a-z][_0-9a-z]*(\.[_a-z][_0-9a-z]*)?';
        px=trim(px)||'/i';
        token=prxparse(px);
        igtoken=prxparse("/^(%?\*|\'|%.*:)/");
        mtoken=prxparse('/^[_a-z][_0-9a-z]*(\.[_a-z][_0-9a-z]*)?$/i');
        lettoken=prxparse('/^[_a-z][_0-9a-z]*\s*=$/i');
        shtoken=prxparse('/^\s*\(.*\)\s*$/i');
        buff=prxchange('s/^\((.*)\)\s*$/$1;/', 1, symget("SYSPBUFF"));
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
        starttoken=prxparse('/^[{]$/');
        stoptoken=prxparse('/^[};]$/');
        start=1;
        stop=length(trim(buff));
        call prxnext(token, start, stop, buff, pos, len);
        last=-1;

        do while(pos>0);

            if sq=0 and mq=0 and bq=0 and last^=-1 and pos>last then
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
                            goto word;
                        end;
                    goto cont;
                end;

            if com=1 or sq=1 or mq=1 or bq>0 then
                goto cont;

            if prxmatch(igtoken, trim(item)) then
                goto cont;
word:

            /* method stack */
            if prxmatch(starttoken, trim(item)) then
                do;
                    id+1;
                    stack[id]=item;

                    if item='{' then
                        bigstatus+1;
                    goto method;
                end;
            else if prxmatch(stoptoken, trim(item)) then
                do;

                    if id=0 then
                        do;

                            if item^=';' then
                                do;
                                    put 'ERROR: Not Complete';
                                    err=1;
                                    goto stop;
                                end;
                        end;
                    else if compress(stack[id]||item)='{}' then
                        do;
                            stack[id]='';
                            id=id-1;
                            bigstatusb=bigstatus-1;
                        end;
                    else
                        do;
                            put 'ERROR: Not Complete';
                            err=1;
                            goto stop;
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
                                    put '%put ' @;

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
                            put '%import(' name +(-1) ');';

                            if bigstatus then
                                do;
                                    put '%let g__=%' name +(-1) '(' @;
                                end;
                            else
                                do;
                                    put '%' name +(-1) '(' @;
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

                            if bigstatus then
                                do;
                                    put '%put &g__.;';
                                end;
endmethod:
                        end;
                    else if prxmatch(lettoken, trim(method[1])) then
                        do;
                            name=compress(method[1], ' =');
                            put '%global g__' name +(-1) ';';
                            put '%let __g__=&__g__. g__' name ';';
                            put '%let g__' method[1] +(-1) @;

                            do i=2 to mid;
                                method[i]=dequote(method[i]);
                                method[i]=prxchange('s/([";'||"'"||'])/%str(%$1)/', 
                                    -1, method[i]);
                                put method[i] +(-1) @;
                            end;
                            put ';';
                        end;
                    mid=0;
                    goto cont;
                end;
            mid+1;

            if mid=1 then
                do;

                    if not prxmatch(mtoken, trim(item)) and not 
                        prxmatch(lettoken, trim(item)) then
                            do;
                            if prxmatch(shtoken, trim(item)) then
                                do;
                                   put '%sh' item +(-1) ';';
                                end;
                            else
                                do;
                                    put 'ERROR: Unknown method ' item;
                                    err=1;
                                    goto stop;
                                end;
                        end;
                end;
            else
                do;

                    if index(item, '"')=1 then
                        do;
                            item=tranwrd(item, '$', '&g__');
                            item=tranwrd(item, '#', 'g__');
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

        if mq or sq or bq then
            do;
                put 'ERROR: Uncomplete code!';
                err=1;
                put _all_;
                goto stop;
            end;
stop:

        if err then
            do;
                call symputx('SYSRC', '1');
            end;
        put '%let __g__=%sort(&__g__.,uniq=1);';
        put '%symdel &__g__.;';
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
                    %put --- SH(&g_sh.): AUTO CREATED CODE >>> START ---;
                    %print(%sysfunc(pathname(&__temp__.)));
                    %put --- SH(&g_sh.): AUTO CREATED CODE <<< END   ---;
                %end;
        %end;
    %option(__option__);
    %inc "%sysfunc(pathname(&__temp__.))";
    %option(__option__);
%exit:
    %ref(__temp__, clear);
    %option(__option__);
    %put NOTE: MACRO<&sysmacroname.(&g_sh.)> run %sysevalf(%sysfunc(time())-&__timestart__.)s.;
    %let g_sh=%eval(&g_sh.-1);
%mend;