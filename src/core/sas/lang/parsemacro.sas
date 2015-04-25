/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(isfileref);

%macro parsemacro(path,fileref);
    %if %length(&path.)=0 %then %return;
    %if not %sysfunc(fileexist(&path.)) %then %return;

    data _null_;
        length px $1024 token 8 igtoken 8 text $100 pos 8 len 8 com 3 sq 3 
            buff $32766 last $100;
        infile "&path." end=eof;

        %if %isfileref(&fileref.) %then
            %do;
                file &fileref.;
            %end;
        input;

        if _n_=1 then
            do;
                px='/\/\*|\*\/|%?\*.*?;';
                px=trim(px)||"|['()]";
                px=trim(px)||'|%[_a-z][_0-9a-z]*?:';
                px=trim(px)||'|[_a-z&][_0-9a-z&]*?=';
                px=trim(px)||'|(%|&+)[_a-z][_0-9a-z&]*\.*/i';
                token=prxparse(px);
                igtoken=prxparse("/^(%?\*|\'|%.*:)/");
                com=0;
                sq=0;
                mq=0;
                last='';
                q='|';
            end;
        buff=_infile_;
        start=1;
        stop=length(buff);
        call prxnext(token, start, stop, buff, pos, len);

        do while(pos>0);
            text=substr(buff, pos, len);

            if text="*/" then
                do;
                    com=0;
                    goto cont;
                end;

            if text="/*" then
                do;
                    com=1;
                    goto cont;
                end;

            if text="'" then
                do;
                    sq=ifn(sq, 0, 1);
                    goto cont;
                end;

            if com=1 or sq=1 then
                goto cont;

            if prxmatch(igtoken, trim(text)) then
                do;
                    goto cont;
                end;
            text=lowcase(text);

            if trim(last)^='%let' and index(trim(text), '=')=length(trim(text)) then
                do;
                    goto cont;
                end;

            %if %isfileref(&fileref.) %then
                %do;
                    put text;
                %end;
            %else
                %do;
                    put text=;
                %end;
            last=text;
cont:
            call prxnext(token, start, stop, buff, pos, len);
        end;
        retain token igtoken com sq last;
    run;

%exit:
%mend;