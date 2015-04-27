/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(ismacroref);
%import(parsemacro);
%import(option);
%import(ref);

%macro dep(name, _list_);
    %local option;
    %option(option);
    %local path;
    %let path=%getpath(&name.);

    %if "&path."="" %then
        %goto exit;
    %local fileref;
    %ref(fileref);
    %parsemacro(&path., &fileref.);

    data _null_;
        length px $1024 systoken 8 token $64 m 8 q $4096;
        infile &fileref. end=eof;
        input token $;

        if _n_=1 then
            do;
                px='/^%(abend|end|length|qkupcase|sysevalf|abort|eval|';
                px=trim(px)||'lowcase|sysmacexec|qcmpres|';
                px=trim(px)||'let|qscan|sysexec|act|file|list|qsubstr|';
                px=trim(px)||'sysfunc|activate|global|listm|';
                px=trim(px)||'qsysfunc|sysget|bquote|go|local|quote|';
                px=trim(px)||'sysrput|by|goto|macro|qupcase|then|clear|';
                px=trim(px)||'if|mend|resolve|to|close|inc|pause|return|';
                px=trim(px)||'tso|cms|include|nrstr|run|unquote|comandr|';
                px=trim(px)||'index|on|save|unstr|copy|infile|open|scan|';
                px=trim(px)||'until|deact|input|put|stop|upcase|del|';
                px=trim(px)||'kcmpres|nrbquote|str|while|delete|kindex|';
                px=trim(px)||'nrquote|syscall|window|display|kleft|metasym|';
                px=trim(px)||'substr|dmidsply|klength|qkcmpres|superq|';
                px=trim(px)||'dmisplit|kscan|qkleft|symdel|do|ksubstr|';
                px=trim(px)||'qkscan|symexist|edit|ktrim|qksubstr|symglobl|';
                px=trim(px)||'else|kupcase|qktrim|symlocal|sysmacdelete)$/i';
                systoken=prxparse(px);
                m=0;
                q='|';
            end;

        if index(token, '%')^=1 then
            goto cont;

        if trim(token)='%macro' then
            do;
                m=m+1;
                goto cont;
            end;
        else if trim(token)='%mend' then
            do;
                m=m-1;
                goto cont;
            end;
        else if prxmatch(systoken, trim(token)) then
            goto cont;

        if trim(token)='%import' and m=0 then
            goto cont;

        if m=0 then
            put 'ERROR: MACRO<' "&name." '> invoke MACRO<' token 
                '> in open area!';
        token=compress(tranwrd(token, '%', ''))||'|';

        if not index(q, '|'||trim(token)) then
            do;
                q=trim(q)||trim(token);
            end;
cont:

        if eof then
            do;
                q=trimn(tranwrd(q, '|', ' '));

                if ""^="&_list_." and symexist("&_list_.") then
                    do;
                        call symputx("&_list_.", q);
                    end;
                else
                    do;
                        put 'MACRO<' "&name." '> has dependencies <' q '>!';
                    end;
            end;
        retain systoken q m;
    run;

    %ref(fileref, clear);
%exit:
    %option(option);
%mend;