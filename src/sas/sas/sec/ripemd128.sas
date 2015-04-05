%macro sas_sec_ripemd128(file, _rmd128_);
    %local num;
    %let num=510;

    data _null_;
        if filename('_rmd128_', "&file.") then
            do;
                put 'error: 文件分配错误!';
                return;
            end;
        length byte $%eval(64*&num.). rmd128 $32.;
        array word[16] (16*0);
        array ka[64] (16*000000000x 16*05a827999x 16*06ed9eba1x 16*08f1bbcdcx);
        array kb[64] (16*050a28be6x 16*05c4dd124x 16*06d703ef3x 16*000000000x);
        array r[64](0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 15 3 12 
            0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 12 1 9 11 10 0 8 
            12 4 13 3 7 15 14 5 6 2);
        array rr[64](5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 13 5 10 
            14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 4 13 8 6 4 1 3 
            11 15 0 5 12 2 13 9 7 10 14);
        array s[64](11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 9 7 15 
            7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 5 12 7 5 11 12 
            14 15 14 15 9 8 9 14 5 6 8 6 5 12);
        array ss[64](8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 12 8 9 
            11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 13 13 7 5 15 5 
            8 11 14 14 6 14 6 9 12 9 12 5 15 8);
        ha=067452301x;
        hb=0efcdab89x;
        hc=098badcfex;
        hd=010325476x;
        iid=fopen('_rmd128_', 'i', 64*&num., 'b');
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
                            word[1]=128;
                        flg=0;
                        i=length;
                        word[15]=mod(n*8, 4294967296);
                        word[16]=int(n*8/4294967296);
                    end;
                else
                    do;

                        if length=64*&num. then
                            do;
                                k=0;

                                do j=1 to 64 by 4;
                                    k+1;
                                    word[k]=input(put(reverse(substr(byte, i+j, 
                                        4)), $hex8.), hex8.);
                                end;
                            end;
                        else
                            do;
                                lenj=min(length-i, 64);
                                k=0;

                                do j=1 to lenj by 4;
                                    k+1;
                                    lenk=min(lenj-j+1, 4);
                                    word[k]=input(put(reverse(substr(byte, i+j, 
                                        lenk)), $hex8.), hex8.);
                                end;

                                if length-i<=64 then
                                    do;

                                        if lenk<4 then
                                            do;
                                                word[k]=word[k]+2**(8*lenk+7);
                                            end;
                                        else
                                            do;

                                                if k<16 then
                                                    word[k+1]=128;
                                                else
                                                    flg=16;
                                            end;

                                        if k<14 then
                                            do;
                                                word[15]=mod(n*8, 4294967296);
                                                word[16]=int(n*8/4294967296);
                                                flg=0;
                                            end;
                                        else if flg=0 then
                                            flg=1;

                                        /*							put k= flg=;*/
                                    end;
                            end;
                    end;
                a=ha;
                b=hb;
                c=hc;
                d=hd;
                aa=ha;
                bb=hb;
                cc=hc;
                dd=hd;

                do j=0 to 63;

                    if j<32 then
                        do;

                            if j<16 then
                                do;
                                    f=bxor(b, bxor(c, d));
                                    ff=bor(band(bb, dd), band(cc, 
                                        4294967295-dd));
                                end;
                            else
                                do;
                                    f=bor(band(b, c), band(4294967295-b, d));
                                    ff=bxor(bor(bb, 4294967295-cc), dd);
                                end;
                        end;
                    else
                        do;

                            if j<48 then
                                do;
                                    f=bxor(bor(b, 4294967295-c), d);
                                    ff=bor(band(bb, cc), band(4294967295-bb, 
                                        dd));
                                end;
                            else
                                do;
                                    f=bor(band(b, d), band(c, 4294967295-d));
                                    ff=bxor(bb, bxor(cc, dd));
                                end;
                        end;
                    t=mod(a+f+word[r[j+1]+1]+ka[j+1], 4294967296);
                    t=bor(blshift(t, s[j+1]), brshift(t, 32-s[j+1]));
                    a=d;
                    d=c;
                    c=b;
                    b=t;
                    t=mod(aa+ff+word[rr[j+1]+1]+kb[j+1], 4294967296);
                    t=bor(blshift(t, ss[j+1]), brshift(t, 32-ss[j+1]));
                    aa=dd;
                    dd=cc;
                    cc=bb;
                    bb=t;
                end;
                t=mod(hb+c+dd, 4294967296);
                hb=mod(hc+d+aa, 4294967296);
                hc=mod(hd+a+bb, 4294967296);
                hd=mod(ha+b+cc, 4294967296);
                ha=t;

                /*				put word[*] hex8. '|';*/
                do j=1 to 16;
                    word[j]=0;
                end;
                i+64;
            end;
        end;
        rc=fclose(iid);
        rc=filename('_rmd128_');
        rmd128=put(left(reverse(input(put(ha, hex8.), $hex8.))), $hex8.) 
            ||put(left(reverse(input(put(hb, hex8.), $hex8.))), $hex8.) 
            ||put(left(reverse(input(put(hc, hex8.), $hex8.))), $hex8.) 
            ||put(left(reverse(input(put(hd, hex8.), $hex8.))), $hex8.);

        if compress("&_rmd128_.")='' then
            do;
                put '文件' "&file." '字节数为' n 'bytes.';
                put rmd128=;
            end;
        else if symexist("&_rmd128_.") then
            call symput("&_rmd128_.", rmd128);
        else
            do;
                rc=filename('rmd128__', "&file..rmd128");
                oid=fopen('rmd128__', 'o', 32, 'b');
                rc=fput(oid, rmd128);
                rc=fwrite(oid);
                rc=fclose(oid);
                rc=filename('rmd128__');
            end;
    run;

%mend;