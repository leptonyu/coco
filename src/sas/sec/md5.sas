%macro sas_sec_md5(file, _md5_);
    %local num;
    %let num=510;

    data _null_;
        if filename('_md5_', "&file.") then
            do;
                put 'ERROR: file allocate failed!';
                return;
            end;
        length byte $%eval(64*&num.). md5 $32.;
        array word[16] (16*0);
        array r[64] (7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22 5 9 14 20 5 9 
            14 20 5 9 14 20 5 9 14 20 4 11 16 23 4 11 16 23 4 11 16 23 4 11 16 
            23 6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 21);
        array kk[64] (0d76aa478x 0e8c7b756x 0242070dbx 0c1bdceeex 0f57c0fafx 
            04787c62ax 0a8304613x 0fd469501x 0698098d8x 08b44f7afx 0ffff5bb1x 
            0895cd7bex 06b901122x 0fd987193x 0a679438ex 049b40821x 0f61e2562x 
            0c040b340x 0265e5a51x 0e9b6c7aax 0d62f105dx 002441453x 0d8a1e681x 
            0e7d3fbc8x 021e1cde6x 0c33707d6x 0f4d50d87x 0455a14edx 0a9e3e905x 
            0fcefa3f8x 0676f02d9x 08d2a4c8ax 0fffa3942x 08771f681x 06d9d6122x 
            0fde5380cx 0a4beea44x 04bdecfa9x 0f6bb4b60x 0bebfbc70x 0289b7ec6x 
            0eaa127fax 0d4ef3085x 004881d05x 0d9d4d039x 0e6db99e5x 01fa27cf8x 
            0c4ac5665x 0f4292244x 0432aff97x 0ab9423a7x 0fc93a039x 0655b59c3x 
            08f0ccc92x 0ffeff47dx 085845dd1x 06fa87e4fx 0fe2ce6e0x 0a3014314x 
            04e0811a1x 0f7537e82x 0bd3af235x 02ad7d2bbx 0eb86d391x);
        ha=067452301x;
        hb=0efcdab89x;
        hc=098badcfex;
        hd=010325476x;
        iid=fopen('_md5_', 'i', 64*&num., 'b');
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

                do j=1 to 64;

                    if j<=32 then
                        do;

                            if j<=16 then
                                do;
                                    f=bor(band(b, c), band(4294967295-b, d));
                                    g=j-1;
                                end;
                            else
                                do;
                                    f=bor(band(d, b), band(4294967295-d, c));
                                    g=mod(5*j-4, 16);
                                end;
                        end;
                    else
                        do;

                            if j<=48 then
                                do;
                                    f=bxor(bxor(b, c), d);
                                    g=mod(3*j+2, 16);
                                end;
                            else
                                do;
                                    f=bxor(c, bor(b, 4294967295-d));
                                    g=mod(7*j-7, 16);
                                end;
                        end;
                    temp=d;
                    d=c;
                    c=b;
                    temp2=mod(a+f+kk[j]+word[g+1], 4294967296);
                    b=mod(bor(blshift(temp2, r[j]), brshift(temp2, 32-r[j]))+b, 
                        4294967296);
                    a=temp;
                end;
                ha=mod(ha+a, 4294967296);
                hb=mod(hb+b, 4294967296);
                hc=mod(hc+c, 4294967296);
                hd=mod(hd+d, 4294967296);

                /*				put word[*] hex8. '|';*/
                do j=1 to 16;
                    word[j]=0;
                end;
                i+64;
            end;
        end;
        rc=fclose(iid);
        rc=filename('_md5_');
        md5=put(left(reverse(input(put(ha, hex8.), $hex8.))), $hex8.) 
            ||put(left(reverse(input(put(hb, hex8.), $hex8.))), $hex8.) 
            ||put(left(reverse(input(put(hc, hex8.), $hex8.))), $hex8.) 
            ||put(left(reverse(input(put(hd, hex8.), $hex8.))), $hex8.);

        if compress("&_md5_.")='' then
            do;
                put 'File ' "&file." ' has ' n 'bytes.';
                put md5=;
            end;
        else if symexist("&_md5_.") then
            call symput("&_md5_.", md5);
        else
            do;
                rc=filename('md5__', "&file..md5");
                oid=fopen('md5__', 'o', 32, 'b');
                rc=fput(oid, md5);
                rc=fwrite(oid);
                rc=fclose(oid);
                rc=filename('md5__');
            end;
    run;

%mend;