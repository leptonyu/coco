/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-09 09:32:34
 * @version 1.0
 *
 *************************************************/

%import(option);
%import(ref);
%import(print);
%import(canonicalname);
%import(getpath);

%macro sh/parmbuff;
    %local __option__ __temp__ __timestart__;
    %let __timestart__=%sysfunc(time());
    %option(__option__);
    %ref(__temp__);

    data _null_;
        length buff $32767 token 8 item $64 px $4096 com 3 ig $1024 name $32;
        array stack{2000} $1024;
        array method{12} $1024;
        file &__temp__.;
        err=0;
        px='/\/\*|\*\/|%?\*.*?;';
        px=trim(px)||'|[(){};"]';
        px=trim(px)||'|[_a-z][_0-9a-z]*\s*=';
        px=trim(px)||'|[_a-z][_0-9a-z]*(\.[_a-z][_0-9a-z]*)?';
        px=trim(px)||'/i';
        token=prxparse(px);
        igtoken=prxparse("/^(%?\*|\'|%.*:)/");
        mtoken=prxparse('/^[_a-z][_0-9a-z]*(\.[_a-z][_0-9a-z]*)?$/i');
        lettoken=prxparse('/^[_a-z][_0-9a-z]*\s*=$/i');
        buff=symget("SYSPBUFF");
        com=0;
        sq=0;
        sqstart=-1;
        new=1;
        id=0;
        mid=0;
        starttoken=prxparse('/[({]/');
        stoptoken=prxparse('/[)};]/');
        start=1;
        stop=length(trim(buff));
        call prxnext(token, start, stop, buff, pos, len);
        last=-1;

        do while(pos>0);

            if sq=0 and last^=-1 and pos>last then
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

            if item='"' then
                do;
                    sq=ifn(sq, 0, 1);

                    if sq=1 then
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

            if com=1 or sq=1 then
                goto cont;

            if prxmatch(igtoken, trim(item)) then
                do;
                    goto cont;
                end;
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

                    if compress(stack[id]||item)='{}' then
                        do;
                            stack[id]='';
                            id=id-1;
                        end;
                    else if compress(stack[id]||item)='()' then
                        do;
                            stack[id]='';
                            id=id-1;
                        end;
                    else if item^=';' then
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
                                        put method[i] @;
                                    end;
                                    put ';';
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
                            put '%' name +(-1) '(' @;

                            do i=2 to mid;

                                if i>2 then
                                    put ',' @;
                                put method[i] +(-1) @;
                            end;
                            put ');';
endmethod:
                        end;
                    else if prxmatch(lettoken, trim(method[1])) then
                        do;
                            put '%let g__' method[1] +(-1) @;

                            do i=2 to mid;
                                put method[i] +(-1) @;
                            end;
                            put ';';
                        end;
                    mid=0;
                    goto cont;
                end;
            else
                do;
                end;
            mid+1;

            if mid=1 then
                do;

                    if prxmatch(mtoken, trim(item)) then
                        do;
                        end;
                    else if prxmatch(lettoken, trim(item)) then
                        do;
                        end;
                    else
                        do;
                            put 'ERROR: Unknown method ' item;
                            err=1;
                            goto stop;
                        end;
                end;
            else
                do;
                    item=dequote(tranwrd(item, '$', '&g__'));
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
stop:

        if err then
            do;
                call symputx('SYSRC', '1');
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
    %option(__option__);
     %inc "%sysfunc(pathname(&__temp__.))"; 
/*     %print(%sysfunc(pathname(&__temp__.))); */
    %option(__option__);
%exit:
    %ref(__temp__, clear);
    %option(__option__);
    %put NOTE: MACRO<&sysmacroname.> run %sysevalf(%sysfunc(time())-&__timestart__.)s.;
%mend;