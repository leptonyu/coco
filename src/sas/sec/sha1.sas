%macro sas_sec_sha1(file, _sha1_);
    %local num;
    %let num=510;

    data _null_;
        if filename('_sha1_', "&file.") then
            do;
                put 'error: 文件分配错误!';
                return;
            end;
        length byte $%eval(64*&num.). sha1 $40.;
        array word[80] (80*0);
        ha=067452301x;
        hb=0efcdab89x;
        hc=098badcfex;
        hd=010325476x;
        he=0c3d2e1f0x;
        length=64*&num.;
        iid=fopen('_sha1_', 'i', length, 'b');
        n=0;
        flg=1;

        do while(fread(iid)=0 or flg);
            length=frlen(iid);
            n+length;

            if length=0 then
                flg=16;
            else
                do;
                    rc=fget(iid, byte, length);
                    flg=0;
                end;
            i=0;

            do while(flg or i<length);

                if flg then
                    do;

                        if flg=16 then
                            word[1]=2147483648;
                        flg=0;
                        i=length;
                        word[16]=mod(n*8, 4294967296);
                        word[15]=int(n*8/4294967296);
                    end;
                else
                    do;

                        if length=64*&num. then
                            do;
                                k=0;

                                do j=1 to 64 by 4;
                                    k+1;
                                    word[k]=input(put(substr(byte, i+j, 4), 
                                        $hex8.), hex8.);
                                end;
                            end;
                        else
                            do;
                                lenj=min(length-i, 64);
                                k=0;

                                do j=1 to lenj by 4;
                                    k+1;
                                    lenk=min(lenj-j+1, 4);
                                    word[k]=input(put(substr(byte, i+j, lenk), 
                                        $hex8.), hex8.);
                                end;

                                if length-i<=64 then
                                    do;

                                        if lenk<4 then
                                            do;
                                                word[k]=word[k]*2**(32-8*lenk)+2**(24-8*lenk+7);
                                            end;
                                        else
                                            do;

                                                if k<16 then
                                                    word[k+1]=2147483648;
                                                else
                                                    flg=16;
                                            end;

                                        if k<14 then
                                            do;
                                                word[16]=mod(n*8, 4294967296);
                                                word[15]=int(n*8/4294967296);
                                                flg=0;
                                            end;
                                        else if flg=0 then
                                            flg=1;

                                        /*							put k= flg=;*/
                                    end;
                            end;
                    end;

                do j=17 to 80;
                    temp=bxor(bxor(word[j-3], word[j-8]), bxor(word[j-14], 
                        word[j-16]));
                    word[j]=bor(blshift(temp, 1), brshift(temp, 31));
                end;

                /*				put word[*] hex8.;*/
                a=ha;
                b=hb;
                c=hc;
                d=hd;
                e=he;

                do j=1 to 80;

                    if j<=40 then
                        do;

                            if j<=20 then
                                do;
                                    f=bor(band(b, c), band(4294967295-b, d));
                                    k=05a827999x;
                                end;
                            else
                                do;
                                    f=bxor(b, bxor(c, d));
                                    k=06ed9eba1x;
                                end;
                        end;
                    else
                        do;

                            if j<=60 then
                                do;
                                    f=bor(bor(band(b, c), band(b, d)), band(c, 
                                        d));
                                    k=08f1bbcdcx;
                                end;
                            else
                                do;
                                    f=bxor(b, bxor(c, d));
                                    k=0ca62c1d6x;
                                end;
                        end;
                    temp=mod(bor(blshift(a, 5), brshift(a, 27))+f+e+k+word[j], 
                        4294967296);
                    e=d;
                    d=c;
                    c=bor(blshift(b, 30), brshift(b, 2));
                    b=a;
                    a=temp;
                end;
                ha=mod(ha+a, 4294967296);
                hb=mod(hb+b, 4294967296);
                hc=mod(hc+c, 4294967296);
                hd=mod(hd+d, 4294967296);
                he=mod(he+e, 4294967296);

                do j=1 to 80;
                    word[j]=0;
                end;
                i+64;
            end;
        end;
        rc=fclose(iid);
        rc=filename('_sha1_');
        sha1=put(ha, hex8.)||put(hb, hex8.)||put(hc, hex8.)||put(hd, 
            hex8.)||put(he, hex8.);

        if compress("&_sha1_.")='' then
            do;
                put '文件' "&file." '字节数为' n 'bytes.';
                put sha1=;
            end;
        else if symexist("&_sha1_.") then
            call symput("&_sha1_.", sha1);
        else
            do;
                rc=filename('sha1__', "&file..sha1");
                oid=fopen('sha1__', 'o', 40, 'b');
                rc=fput(oid, sha1);
                rc=fwrite(oid);
                rc=fclose(oid);
                rc=filename('sha1__');
            end;
    run;

%mend;