%import(option);
%import(ref);

%macro sas_sec_cksum(file, _cksum_, type=md5);
    %local option;
    %option(option);
    %local filename;
    %let filename=&file.;

    %if %length(&filename.)=0 %then
        %do;
            %put ERROR: Empty parameter!;
            %goto error;
        %end;

    %if not %sysfunc(fileexist(&filename.)) %then
        %do;
            %put ERROR: File &file. not exist!;
            %goto error;
        %end;
    %ref(filename);

    %if "__err"="&filename." %then
        %do;
            %put ERROR: Cannot allocate file &file.!;
            %goto error;
        %end;

    %if %sysfunc(compress("&_cksum_."))="" %then
        %do;
            %local sum;
            %let _cksum_=sum;
        %end;
    %else %if not %symexist(&_cksum_.) %then
        %do;
            %local sum;
            %let _cksum_=sum;
        %end;
    %local num;

    %if %lowcase("&type.")="crc32" %then
        %do;
            %let num=32766;

            data _null_;
                array crctable[256] (000000000x 077073096x 0ee0e612cx 
                    0990951bax 0076dc419x 0706af48fx 0e963a535x 09e6495a3x 
                    00edb8832x 079dcb8a4x 0e0d5e91ex 097d2d988x 009b64c2bx 
                    07eb17cbdx 0e7b82d07x 090bf1d91x 01db71064x 06ab020f2x 
                    0f3b97148x 084be41dex 01adad47dx 06ddde4ebx 0f4d4b551x 
                    083d385c7x 0136c9856x 0646ba8c0x 0fd62f97ax 08a65c9ecx 
                    014015c4fx 063066cd9x 0fa0f3d63x 08d080df5x 03b6e20c8x 
                    04c69105ex 0d56041e4x 0a2677172x 03c03e4d1x 04b04d447x 
                    0d20d85fdx 0a50ab56bx 035b5a8fax 042b2986cx 0dbbbc9d6x 
                    0acbcf940x 032d86ce3x 045df5c75x 0dcd60dcfx 0abd13d59x 
                    026d930acx 051de003ax 0c8d75180x 0bfd06116x 021b4f4b5x 
                    056b3c423x 0cfba9599x 0b8bda50fx 02802b89ex 05f058808x 
                    0c60cd9b2x 0b10be924x 02f6f7c87x 058684c11x 0c1611dabx 
                    0b6662d3dx 076dc4190x 001db7106x 098d220bcx 0efd5102ax 
                    071b18589x 006b6b51fx 09fbfe4a5x 0e8b8d433x 07807c9a2x 
                    00f00f934x 09609a88ex 0e10e9818x 07f6a0dbbx 0086d3d2dx 
                    091646c97x 0e6635c01x 06b6b51f4x 01c6c6162x 0856530d8x 
                    0f262004ex 06c0695edx 01b01a57bx 08208f4c1x 0f50fc457x 
                    065b0d9c6x 012b7e950x 08bbeb8eax 0fcb9887cx 062dd1ddfx 
                    015da2d49x 08cd37cf3x 0fbd44c65x 04db26158x 03ab551cex 
                    0a3bc0074x 0d4bb30e2x 04adfa541x 03dd895d7x 0a4d1c46dx 
                    0d3d6f4fbx 04369e96ax 0346ed9fcx 0ad678846x 0da60b8d0x 
                    044042d73x 033031de5x 0aa0a4c5fx 0dd0d7cc9x 05005713cx 
                    0270241aax 0be0b1010x 0c90c2086x 05768b525x 0206f85b3x 
                    0b966d409x 0ce61e49fx 05edef90ex 029d9c998x 0b0d09822x 
                    0c7d7a8b4x 059b33d17x 02eb40d81x 0b7bd5c3bx 0c0ba6cadx 
                    0edb88320x 09abfb3b6x 003b6e20cx 074b1d29ax 0ead54739x 
                    09dd277afx 004db2615x 073dc1683x 0e3630b12x 094643b84x 
                    00d6d6a3ex 07a6a5aa8x 0e40ecf0bx 09309ff9dx 00a00ae27x 
                    07d079eb1x 0f00f9344x 08708a3d2x 01e01f268x 06906c2fex 
                    0f762575dx 0806567cbx 0196c3671x 06e6b06e7x 0fed41b76x 
                    089d32be0x 010da7a5ax 067dd4accx 0f9b9df6fx 08ebeeff9x 
                    017b7be43x 060b08ed5x 0d6d6a3e8x 0a1d1937ex 038d8c2c4x 
                    04fdff252x 0d1bb67f1x 0a6bc5767x 03fb506ddx 048b2364bx 
                    0d80d2bdax 0af0a1b4cx 036034af6x 041047a60x 0df60efc3x 
                    0a867df55x 0316e8eefx 04669be79x 0cb61b38cx 0bc66831ax 
                    0256fd2a0x 05268e236x 0cc0c7795x 0bb0b4703x 0220216b9x 
                    05505262fx 0c5ba3bbex 0b2bd0b28x 02bb45a92x 05cb36a04x 
                    0c2d7ffa7x 0b5d0cf31x 02cd99e8bx 05bdeae1dx 09b64c2b0x 
                    0ec63f226x 0756aa39cx 0026d930ax 09c0906a9x 0eb0e363fx 
                    072076785x 005005713x 095bf4a82x 0e2b87a14x 07bb12baex 
                    00cb61b38x 092d28e9bx 0e5d5be0dx 07cdcefb7x 00bdbdf21x 
                    086d3d2d4x 0f1d4e242x 068ddb3f8x 01fda836ex 081be16cdx 
                    0f6b9265bx 06fb077e1x 018b74777x 088085ae6x 0ff0f6a70x 
                    066063bcax 011010b5cx 08f659effx 0f862ae69x 0616bffd3x 
                    0166ccf45x 0a00ae278x 0d70dd2eex 04e048354x 03903b3c2x 
                    0a7672661x 0d06016f7x 04969474dx 03e6e77dbx 0aed16a4ax 
                    0d9d65adcx 040df0b66x 037d83bf0x 0a9bcae53x 0debb9ec5x 
                    047b2cf7fx 030b5ffe9x 0bdbdf21cx 0cabac28ax 053b39330x 
                    024b4a3a6x 0bad03605x 0cdd70693x 054de5729x 023d967bfx 
                    0b3667a2ex 0c4614ab8x 05d681b02x 02a6f2b94x 0b40bbe37x 
                    0c30c8ea1x 05a05df1bx 02d02ef8dx);
                ha=0ffffffffx;
                length byte $&num.. crc32 $8.;
                iid=fopen("&filename.", 'i', &num., 'b');
                n=0;

                do while(fread(iid)=0);
                    length=frlen(iid);
                    n+length;
                    rc=fget(iid, byte, length);
                    i=0;

                    do while(i<length);
                        i+1;
                        ha=bxor(brshift(ha, 08x), crctable[bxor(band(ha, 0ffx), 
                            rank(char(byte, i)))+1]);
                    end;
                end;
                rc=fclose(iid);
                crc32=put(bnot(ha), hex8.);
                call symput("&_cksum_.", crc32);
            run;

        %end;
    %else %if %lowcase("&type.")="md5" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). md5 $32.;
                array word[16] (16*0);
                array r[64] (7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22 5 9 14 
                    20 5 9 14 20 5 9 14 20 5 9 14 20 4 11 16 23 4 11 16 23 4 11 
                    16 23 4 11 16 23 6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 
                    21);
                array kk[64] (0d76aa478x 0e8c7b756x 0242070dbx 0c1bdceeex 
                    0f57c0fafx 04787c62ax 0a8304613x 0fd469501x 0698098d8x 
                    08b44f7afx 0ffff5bb1x 0895cd7bex 06b901122x 0fd987193x 
                    0a679438ex 049b40821x 0f61e2562x 0c040b340x 0265e5a51x 
                    0e9b6c7aax 0d62f105dx 002441453x 0d8a1e681x 0e7d3fbc8x 
                    021e1cde6x 0c33707d6x 0f4d50d87x 0455a14edx 0a9e3e905x 
                    0fcefa3f8x 0676f02d9x 08d2a4c8ax 0fffa3942x 08771f681x 
                    06d9d6122x 0fde5380cx 0a4beea44x 04bdecfa9x 0f6bb4b60x 
                    0bebfbc70x 0289b7ec6x 0eaa127fax 0d4ef3085x 004881d05x 
                    0d9d4d039x 0e6db99e5x 01fa27cf8x 0c4ac5665x 0f4292244x 
                    0432aff97x 0ab9423a7x 0fc93a039x 0655b59c3x 08f0ccc92x 
                    0ffeff47dx 085845dd1x 06fa87e4fx 0fe2ce6e0x 0a3014314x 
                    04e0811a1x 0f7537e82x 0bd3af235x 02ad7d2bbx 0eb86d391x);
                ha=067452301x;
                hb=0efcdab89x;
                hc=098badcfex;
                hd=010325476x;
                iid=fopen("&filename.", 'i', 64*&num., 'b');
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
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, 4)), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, lenk)), $hex8.), hex8.);
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
                                                        word[15]=mod(n*8, 
                                                            4294967296);
                                                        word[16]=int(n*8/4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
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
                                            f=bor(band(b, c), 
                                                band(4294967295-b, d));
                                            g=j-1;
                                        end;
                                    else
                                        do;
                                            f=bor(band(d, b), 
                                                band(4294967295-d, c));
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
                            b=mod(bor(blshift(temp2, r[j]), brshift(temp2, 
                                32-r[j]))+b, 4294967296);
                            a=temp;
                        end;
                        ha=mod(ha+a, 4294967296);
                        hb=mod(hb+b, 4294967296);
                        hc=mod(hc+c, 4294967296);
                        hd=mod(hd+d, 4294967296);

                        /*              put word[*] hex8. '|';*/
                        do j=1 to 16;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                md5=put(left(reverse(input(put(ha, hex8.), $hex8.))), $hex8.) 
                    ||put(left(reverse(input(put(hb, hex8.), $hex8.))), $hex8.) 
                    ||put(left(reverse(input(put(hc, hex8.), $hex8.))), $hex8.) 
                    ||put(left(reverse(input(put(hd, hex8.), $hex8.))), $hex8.);
                call symput("&_cksum_.", md5);
            run;

        %end;
    %else %if %lowcase("&type.")="sha1" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). sha1 $40.;
                array word[80] (80*0);
                ha=067452301x;
                hb=0efcdab89x;
                hc=098badcfex;
                hd=010325476x;
                he=0c3d2e1f0x;
                length=64*&num.;
                iid=fopen("&filename.", 'i', length, 'b');
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
                                            word[k]=input(put(substr(byte, i+j, 
                                                4), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(substr(byte, i+j, 
                                                lenk), $hex8.), hex8.);
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
                                                        word[16]=mod(n*8, 
                                                            4294967296);
                                                        word[15]=int(n*8/4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
                                            end;
                                    end;
                            end;

                        do j=17 to 80;
                            temp=bxor(bxor(word[j-3], word[j-8]), 
                                bxor(word[j-14], word[j-16]));
                            word[j]=bor(blshift(temp, 1), brshift(temp, 31));
                        end;

                        /*              put word[*] hex8.;*/
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
                                            f=bor(band(b, c), 
                                                band(4294967295-b, d));
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
                                            f=bor(bor(band(b, c), band(b, d)), 
                                                band(c, d));
                                            k=08f1bbcdcx;
                                        end;
                                    else
                                        do;
                                            f=bxor(b, bxor(c, d));
                                            k=0ca62c1d6x;
                                        end;
                                end;
                            temp=mod(bor(blshift(a, 5), brshift(a, 
                                27))+f+e+k+word[j], 4294967296);
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
                call symput("&_cksum_.", sha1);
            run;

        %end;
    %else %if %lowcase("&type.")="sha224" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). sha224 $56.;
                array word[64] (64*0);
                ha=0c1059ed8x;
                hb=0367cd507x;
                hc=03070dd17x;
                hd=0f70e5939x;
                he=0ffc00b31x;
                hf=068581511x;
                hg=064f98fa7x;
                hh=0befa4fa4x;
                array kk[64] (0428a2f98x 071374491x 0b5c0fbcfx 0e9b5dba5x 
                    03956c25bx 059f111f1x 0923f82a4x 0ab1c5ed5x 0d807aa98x 
                    012835b01x 0243185bex 0550c7dc3x 072be5d74x 080deb1fex 
                    09bdc06a7x 0c19bf174x 0e49b69c1x 0efbe4786x 00fc19dc6x 
                    0240ca1ccx 02de92c6fx 04a7484aax 05cb0a9dcx 076f988dax 
                    0983e5152x 0a831c66dx 0b00327c8x 0bf597fc7x 0c6e00bf3x 
                    0d5a79147x 006ca6351x 014292967x 027b70a85x 02e1b2138x 
                    04d2c6dfcx 053380d13x 0650a7354x 0766a0abbx 081c2c92ex 
                    092722c85x 0a2bfe8a1x 0a81a664bx 0c24b8b70x 0c76c51a3x 
                    0d192e819x 0d6990624x 0f40e3585x 0106aa070x 019a4c116x 
                    01e376c08x 02748774cx 034b0bcb5x 0391c0cb3x 04ed8aa4ax 
                    05b9cca4fx 0682e6ff3x 0748f82eex 078a5636fx 084c87814x 
                    08cc70208x 090befffax 0a4506cebx 0bef9a3f7x 0c67178f2x);
                length=64*&num.;
                iid=fopen("&filename.", 'i', length, 'b');
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
                                word[15]=int(n*8/4294967296);
                                word[16]=mod(n*8, 4294967296);
                            end;
                        else
                            do;

                                if length=64*&num. then
                                    do;
                                        k=0;

                                        do j=1 to 64 by 4;
                                            k+1;
                                            word[k]=input(put(substr(byte, i+j, 
                                                4), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(substr(byte, i+j, 
                                                lenk), $hex8.), hex8.);
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
                                                        word[15]=int(n*8/4294967296);
                                                        word[16]=mod(n*8, 
                                                            4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
                                            end;
                                    end;
                            end;

                        do j=17 to 64;
                            word[j]=mod(word[j-16]+word[j-7]

                                                           +bxor(bxor(bor(blshift(word[j-15], 
                                25), brshift(word[j-15], 7)) , 
                                bor(blshift(word[j-15], 14), 
                                brshift(word[j-15], 18))) , brshift(word[j-15], 
                                3)) +bxor(bxor(bor(blshift(word[j- 2], 15), 
                                brshift(word[j- 2], 17)) , 
                                bor(blshift(word[j- 2], 13), 
                                brshift(word[j- 2], 19))) , brshift(word[j- 2], 
                                10)) , 4294967296);
                        end;

                        /*              put word[*] hex8.;*/
                        /*put '';*/
                        a=ha;
                        b=hb;
                        c=hc;
                        d=hd;
                        e=he;
                        f=hf;
                        g=hg;
                        h=hh;

                        do j=1 to 64;

                            /*              put j= @10 a hex8. '|' b hex8. '|' c hex8. '|' d hex8. '|' e hex8. '|' f hex8. '|' g hex8. '|' h hex8.;*/
                            tb=bxor(bxor(bor(blshift(a, 30), brshift(a, 2)) , 
                                bor(blshift(a, 19), brshift(a, 13))) , 
                                bor(blshift(a, 10), brshift(a, 22))) 
                                +bxor(bxor(band(a, b), band(a, c)), band(b, c));
                            ta=h+kk[j]+word[j]
                      +bxor(bxor(bor(blshift(e, 26), 
                                brshift(e, 6)) , bor(blshift(e, 21), brshift(e, 
                                11))) , bor(blshift(e, 7), brshift(e, 25))) 
                                +bxor(band(e, f), band(4294967295-e, g));
                            h=g;
                            g=f;
                            f=e;
                            e=mod(d+ta, 4294967296);
                            d=c;
                            c=b;
                            b=a;
                            a=mod(ta+tb, 4294967296);
                        end;
                        ha=mod(ha+a, 4294967296);
                        hb=mod(hb+b, 4294967296);
                        hc=mod(hc+c, 4294967296);
                        hd=mod(hd+d, 4294967296);
                        he=mod(he+e, 4294967296);
                        hf=mod(hf+f, 4294967296);
                        hg=mod(hg+g, 4294967296);
                        hh=mod(hh+h, 4294967296);

                        do j=1 to 64;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                rc=filename('_sha224_');
                sha224=put(ha, hex8.)||put(hb, hex8.)||put(hc, hex8.)||put(hd, 
                    hex8.)||put(he, hex8.)||put(hf, hex8.)||put(hg, hex8.);
                call symput("&_cksum_.", sha224);
            run;

        %end;
    %else %if %lowcase("&type.")="sha256" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). sha256 $64.;
                array word[64] (64*0);
                ha=06a09e667x;
                hb=0bb67ae85x;
                hc=03c6ef372x;
                hd=0a54ff53ax;
                he=0510e527fx;
                hf=09b05688cx;
                hg=01f83d9abx;
                hh=05be0cd19x;
                array kk[64] (0428a2f98x 071374491x 0b5c0fbcfx 0e9b5dba5x 
                    03956c25bx 059f111f1x 0923f82a4x 0ab1c5ed5x 0d807aa98x 
                    012835b01x 0243185bex 0550c7dc3x 072be5d74x 080deb1fex 
                    09bdc06a7x 0c19bf174x 0e49b69c1x 0efbe4786x 00fc19dc6x 
                    0240ca1ccx 02de92c6fx 04a7484aax 05cb0a9dcx 076f988dax 
                    0983e5152x 0a831c66dx 0b00327c8x 0bf597fc7x 0c6e00bf3x 
                    0d5a79147x 006ca6351x 014292967x 027b70a85x 02e1b2138x 
                    04d2c6dfcx 053380d13x 0650a7354x 0766a0abbx 081c2c92ex 
                    092722c85x 0a2bfe8a1x 0a81a664bx 0c24b8b70x 0c76c51a3x 
                    0d192e819x 0d6990624x 0f40e3585x 0106aa070x 019a4c116x 
                    01e376c08x 02748774cx 034b0bcb5x 0391c0cb3x 04ed8aa4ax 
                    05b9cca4fx 0682e6ff3x 0748f82eex 078a5636fx 084c87814x 
                    08cc70208x 090befffax 0a4506cebx 0bef9a3f7x 0c67178f2x);
                length=64*&num.;
                iid=fopen("&filename.", 'i', length, 'b');
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
                                word[15]=int(n*8/4294967296);
                                word[16]=mod(n*8, 4294967296);
                            end;
                        else
                            do;

                                if length=64*&num. then
                                    do;
                                        k=0;

                                        do j=1 to 64 by 4;
                                            k+1;
                                            word[k]=input(put(substr(byte, i+j, 
                                                4), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(substr(byte, i+j, 
                                                lenk), $hex8.), hex8.);
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
                                                        word[15]=int(n*8/4294967296);
                                                        word[16]=mod(n*8, 
                                                            4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
                                            end;
                                    end;
                            end;

                        do j=17 to 64;
                            word[j]=mod(word[j-16]+word[j-7]

                                                           +bxor(bxor(bor(blshift(word[j-15], 
                                25), brshift(word[j-15], 7)) , 
                                bor(blshift(word[j-15], 14), 
                                brshift(word[j-15], 18))) , brshift(word[j-15], 
                                3)) +bxor(bxor(bor(blshift(word[j- 2], 15), 
                                brshift(word[j- 2], 17)) , 
                                bor(blshift(word[j- 2], 13), 
                                brshift(word[j- 2], 19))) , brshift(word[j- 2], 
                                10)) , 4294967296);
                        end;

                        /*              put word[*] hex8.;*/
                        /*put '';*/
                        a=ha;
                        b=hb;
                        c=hc;
                        d=hd;
                        e=he;
                        f=hf;
                        g=hg;
                        h=hh;

                        do j=1 to 64;

                            /*              put j= @10 a hex8. '|' b hex8. '|' c hex8. '|' d hex8. '|' e hex8. '|' f hex8. '|' g hex8. '|' h hex8.;*/
                            tb=bxor(bxor(bor(blshift(a, 30), brshift(a, 2)) , 
                                bor(blshift(a, 19), brshift(a, 13))) , 
                                bor(blshift(a, 10), brshift(a, 22))) 
                                +bxor(bxor(band(a, b), band(a, c)), band(b, c));
                            ta=h+kk[j]+word[j]
                      +bxor(bxor(bor(blshift(e, 26), 
                                brshift(e, 6)) , bor(blshift(e, 21), brshift(e, 
                                11))) , bor(blshift(e, 7), brshift(e, 25))) 
                                +bxor(band(e, f), band(4294967295-e, g));
                            h=g;
                            g=f;
                            f=e;
                            e=mod(d+ta, 4294967296);
                            d=c;
                            c=b;
                            b=a;
                            a=mod(ta+tb, 4294967296);
                        end;
                        ha=mod(ha+a, 4294967296);
                        hb=mod(hb+b, 4294967296);
                        hc=mod(hc+c, 4294967296);
                        hd=mod(hd+d, 4294967296);
                        he=mod(he+e, 4294967296);
                        hf=mod(hf+f, 4294967296);
                        hg=mod(hg+g, 4294967296);
                        hh=mod(hh+h, 4294967296);

                        do j=1 to 64;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                rc=filename('_sha256_');
                sha256=put(ha, hex8.)||put(hb, hex8.)||put(hc, hex8.)||put(hd, 
                    hex8.)||put(he, hex8.)||put(hf, hex8.)||put(hg, 
                    hex8.)||put(hh, hex8.);
                call symput("&_cksum_.", sha256);
            run;

        %end;
    %else %if %lowcase("&type.")="ripemd128" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). rmd128 $32.;
                array word[16] (16*0);
                array ka[64] (16*000000000x 16*05a827999x 16*06ed9eba1x 
                    16*08f1bbcdcx);
                array kb[64] (16*050a28be6x 16*05c4dd124x 16*06d703ef3x 
                    16*000000000x);
                array r[64](0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 
                    15 3 12 0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 
                    12 1 9 11 10 0 8 12 4 13 3 7 15 14 5 6 2);
                array rr[64](5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 
                    13 5 10 14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 
                    4 13 8 6 4 1 3 11 15 0 5 12 2 13 9 7 10 14);
                array s[64](11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 
                    9 7 15 7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 
                    5 12 7 5 11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12);
                array ss[64](8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 
                    12 8 9 11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 
                    13 13 7 5 15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8);
                ha=067452301x;
                hb=0efcdab89x;
                hc=098badcfex;
                hd=010325476x;
                iid=fopen("&filename.", 'i', 64*&num., 'b');
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
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, 4)), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, lenk)), $hex8.), hex8.);
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
                                                        word[15]=mod(n*8, 
                                                            4294967296);
                                                        word[16]=int(n*8/4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
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
                                            f=bor(band(b, c), 
                                                band(4294967295-b, d));
                                            ff=bxor(bor(bb, 4294967295-cc), dd);
                                        end;
                                end;
                            else
                                do;

                                    if j<48 then
                                        do;
                                            f=bxor(bor(b, 4294967295-c), d);
                                            ff=bor(band(bb, cc), 
                                                band(4294967295-bb, dd));
                                        end;
                                    else
                                        do;
                                            f=bor(band(b, d), band(c, 
                                                4294967295-d));
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

                        /*              put word[*] hex8. '|';*/
                        do j=1 to 16;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                rc=filename('_rmd128_');
                rmd128=put(left(reverse(input(put(ha, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hb, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hc, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hd, hex8.), $hex8.))), 
                    $hex8.);
                call symput("&_cksum_.", rmd128);
            run;

        %end;
    %else %if %lowcase("&type.")="ripemd160" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). rmd160 $40.;
                array word[16] (16*0);
                array ka[80] (16*000000000x 16*05a827999x 16*06ed9eba1x 
                    16*08f1bbcdcx 16*0a953fd4ex);
                array kb[80] (16*050a28be6x 16*05c4dd124x 16*06d703ef3x 
                    16*07a6d76e9x 16*000000000x);
                array r[80](0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 
                    15 3 12 0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 
                    12 1 9 11 10 0 8 12 4 13 3 7 15 14 5 6 2 4 0 5 9 7 12 2 10 
                    14 1 3 8 11 6 15 13);
                array rr[80](5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 
                    13 5 10 14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 
                    4 13 8 6 4 1 3 11 15 0 5 12 2 13 9 7 10 14 12 15 10 4 1 5 8 
                    7 6 2 13 14 0 3 9 11);
                array s[80](11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 
                    9 7 15 7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 
                    5 12 7 5 11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12 9 15 5 11 
                    6 8 13 12 5 12 13 14 11 8 5 6);
                array ss[80](8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 
                    12 8 9 11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 
                    13 13 7 5 15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8 8 5 12 9 
                    12 5 14 6 8 13 6 5 15 13 11 11);
                ha=067452301x;
                hb=0efcdab89x;
                hc=098badcfex;
                hd=010325476x;
                he=0c3d2e1f0x;
                iid=fopen("&filename.", 'i', 64*&num., 'b');
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
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, 4)), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, lenk)), $hex8.), hex8.);
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
                                                        word[15]=mod(n*8, 
                                                            4294967296);
                                                        word[16]=int(n*8/4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
                                            end;
                                    end;
                            end;
                        a=ha;
                        b=hb;
                        c=hc;
                        d=hd;
                        e=he;
                        aa=ha;
                        bb=hb;
                        cc=hc;
                        dd=hd;
                        ee=he;

                        do j=0 to 79;

                            if j<32 then
                                do;

                                    if j<16 then
                                        do;
                                            f=bxor(b, bxor(c, d));
                                            ff=bxor(bb, bor(cc, 4294967295-dd));
                                        end;
                                    else
                                        do;
                                            f=bor(band(b, c), 
                                                band(4294967295-b, d));
                                            ff=bor(band(bb, dd), band(cc, 
                                                4294967295-dd));
                                        end;
                                end;
                            else if j<64 then
                                do;

                                    if j<48 then
                                        do;
                                            f=bxor(bor(b, 4294967295-c), d);
                                            ff=bxor(bor(bb, 4294967295-cc), dd);
                                        end;
                                    else
                                        do;
                                            f=bor(band(b, d), band(c, 
                                                4294967295-d));
                                            ff=bor(band(bb, cc), 
                                                band(4294967295-bb, dd));
                                        end;
                                end;
                            else
                                do;
                                    f=bxor(b, bor(c, 4294967295-d));
                                    ff=bxor(bb, bxor(cc, dd));
                                end;
                            t=mod(a+f+word[r[j+1]+1]+ka[j+1], 4294967296);
                            t=mod(bor(blshift(t, s[j+1]), brshift(t, 
                                32-s[j+1]))+e, 4294967296);
                            a=e;
                            e=d;
                            d=bor(blshift(c, 10), brshift(c, 22));
                            c=b;
                            b=t;
                            t=mod(aa+ff+word[rr[j+1]+1]+kb[j+1], 4294967296);
                            t=mod(bor(blshift(t, ss[j+1]), brshift(t, 
                                32-ss[j+1]))+ee, 4294967296);
                            aa=ee;
                            ee=dd;
                            dd=bor(blshift(cc, 10), brshift(cc, 22));
                            cc=bb;
                            bb=t;
                        end;
                        t=mod(hb+c+dd, 4294967296);
                        hb=mod(hc+d+ee, 4294967296);
                        hc=mod(hd+e+aa, 4294967296);
                        hd=mod(he+a+bb, 4294967296);
                        he=mod(ha+b+cc, 4294967296);
                        ha=t;

                        /*              put word[*] hex8. '|';*/
                        do j=1 to 16;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                rc=filename('_rmd160_');
                rmd160=put(left(reverse(input(put(ha, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hb, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hc, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hd, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(he, hex8.), $hex8.))), 
                    $hex8.);
                call symput("&_cksum_.", rmd160);
            run;

        %end;
    %else %if %lowcase("&type.")="ripemd256" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). rmd256 $64.;
                array word[16] (16*0);
                array ka[64] (16*000000000x 16*05a827999x 16*06ed9eba1x 
                    16*08f1bbcdcx);
                array kb[64] (16*050a28be6x 16*05c4dd124x 16*06d703ef3x 
                    16*000000000x);
                array r[64](0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 
                    15 3 12 0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 
                    12 1 9 11 10 0 8 12 4 13 3 7 15 14 5 6 2);
                array rr[64](5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 
                    13 5 10 14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 
                    4 13 8 6 4 1 3 11 15 0 5 12 2 13 9 7 10 14);
                array s[64](11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 
                    9 7 15 7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 
                    5 12 7 5 11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12);
                array ss[64](8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 
                    12 8 9 11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 
                    13 13 7 5 15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8);
                ha=067452301x;
                hb=0efcdab89x;
                hc=098badcfex;
                hd=010325476x;
                he=076543210x;
                hf=0fedcba98x;
                hg=089abcdefx;
                hi=001234567x;
                iid=fopen("&filename.", 'i', 64*&num., 'b');
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
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, 4)), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, lenk)), $hex8.), hex8.);
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
                                                        word[15]=mod(n*8, 
                                                            4294967296);
                                                        word[16]=int(n*8/4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
                                            end;
                                    end;
                            end;
                        a=ha;
                        b=hb;
                        c=hc;
                        d=hd;
                        aa=he;
                        bb=hf;
                        cc=hg;
                        dd=hi;

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
                                            f=bor(band(b, c), 
                                                band(4294967295-b, d));
                                            ff=bxor(bor(bb, 4294967295-cc), dd);
                                        end;
                                end;
                            else
                                do;

                                    if j<48 then
                                        do;
                                            f=bxor(bor(b, 4294967295-c), d);
                                            ff=bor(band(bb, cc), 
                                                band(4294967295-bb, dd));
                                        end;
                                    else
                                        do;
                                            f=bor(band(b, d), band(c, 
                                                4294967295-d));
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

                            if j=15 then
                                do;
                                    t=a;
                                    a=aa;
                                    aa=t;
                                end;
                            else if j=31 then
                                do;
                                    t=b;
                                    b=bb;
                                    bb=t;
                                end;
                            else if j=47 then
                                do;
                                    t=c;
                                    c=cc;
                                    cc=t;
                                end;
                            else if j=63 then
                                do;
                                    t=d;
                                    d=dd;
                                    dd=t;
                                end;
                        end;
                        ha=mod(ha+a, 4294967296);
                        hb=mod(hb+b, 4294967296);
                        hc=mod(hc+c, 4294967296);
                        hd=mod(hd+d, 4294967296);
                        he=mod(he+aa, 4294967296);
                        hf=mod(hf+bb, 4294967296);
                        hg=mod(hg+cc, 4294967296);
                        hi=mod(hi+dd, 4294967296);

                        /*              put word[*] hex8. '|';*/
                        do j=1 to 16;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                rc=filename('_rmd256_');
                rmd256=put(left(reverse(input(put(ha, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hb, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hc, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hd, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(he, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hf, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hg, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hi, hex8.), $hex8.))), 
                    $hex8.);
                call symput("&_cksum_.", rmd256);
            run;

        %end;
    %else %if %lowcase("&type.")="ripemd320" %then
        %do;
            %let num=510;

            data _null_;
                length byte $%eval(64*&num.). rmd320 $80.;
                array word[16] (16*0);
                array ka[80] (16*000000000x 16*05a827999x 16*06ed9eba1x 
                    16*08f1bbcdcx 16*0a953fd4ex);
                array kb[80] (16*050a28be6x 16*05c4dd124x 16*06d703ef3x 
                    16*07a6d76e9x 16*000000000x);
                array r[80](0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 7 4 13 1 10 6 
                    15 3 12 0 9 5 2 14 11 8 3 10 14 4 9 15 8 1 2 7 0 6 13 11 5 
                    12 1 9 11 10 0 8 12 4 13 3 7 15 14 5 6 2 4 0 5 9 7 12 2 10 
                    14 1 3 8 11 6 15 13);
                array rr[80](5 14 7 0 9 2 11 4 13 6 15 8 1 10 3 12 6 11 3 7 0 
                    13 5 10 14 15 8 12 4 9 1 2 15 5 1 3 7 14 6 9 11 8 12 2 10 0 
                    4 13 8 6 4 1 3 11 15 0 5 12 2 13 9 7 10 14 12 15 10 4 1 5 8 
                    7 6 2 13 14 0 3 9 11);
                array s[80](11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8 7 6 8 13 11 
                    9 7 15 7 12 15 9 11 7 13 12 11 13 6 7 14 9 13 15 14 8 13 6 
                    5 12 7 5 11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12 9 15 5 11 
                    6 8 13 12 5 12 13 14 11 8 5 6);
                array ss[80](8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6 9 13 15 7 
                    12 8 9 11 7 7 12 7 6 15 13 11 9 7 15 11 8 6 6 14 12 13 5 14 
                    13 13 7 5 15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8 8 5 12 9 
                    12 5 14 6 8 13 6 5 15 13 11 11);
                ha=067452301x;
                hb=0efcdab89x;
                hc=098badcfex;
                hd=010325476x;
                he=0c3d2e1f0x;
                hf=076543210x;
                hg=0fedcba98x;
                hi=089abcdefx;
                hj=001234567x;
                hk=03c2d1e0fx;
                iid=fopen("&filename.", 'i', 64*&num., 'b');
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
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, 4)), $hex8.), hex8.);
                                        end;
                                    end;
                                else
                                    do;
                                        lenj=min(length-i, 64);
                                        k=0;

                                        do j=1 to lenj by 4;
                                            k+1;
                                            lenk=min(lenj-j+1, 4);
                                            word[k]=input(put(reverse(substr(byte, 
                                                i+j, lenk)), $hex8.), hex8.);
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
                                                        word[15]=mod(n*8, 
                                                            4294967296);
                                                        word[16]=int(n*8/4294967296);
                                                        flg=0;
                                                    end;
                                                else if flg=0 then
                                                    flg=1;

                                                /*                          put k= flg=;*/
                                            end;
                                    end;
                            end;
                        a=ha;
                        b=hb;
                        c=hc;
                        d=hd;
                        e=he;
                        aa=hf;
                        bb=hg;
                        cc=hi;
                        dd=hj;
                        ee=hk;

                        do j=0 to 79;

                            if j<32 then
                                do;

                                    if j<16 then
                                        do;
                                            f=bxor(b, bxor(c, d));
                                            ff=bxor(bb, bor(cc, 4294967295-dd));
                                        end;
                                    else
                                        do;
                                            f=bor(band(b, c), 
                                                band(4294967295-b, d));
                                            ff=bor(band(bb, dd), band(cc, 
                                                4294967295-dd));
                                        end;
                                end;
                            else if j<64 then
                                do;

                                    if j<48 then
                                        do;
                                            f=bxor(bor(b, 4294967295-c), d);
                                            ff=bxor(bor(bb, 4294967295-cc), dd);
                                        end;
                                    else
                                        do;
                                            f=bor(band(b, d), band(c, 
                                                4294967295-d));
                                            ff=bor(band(bb, cc), 
                                                band(4294967295-bb, dd));
                                        end;
                                end;
                            else
                                do;
                                    f=bxor(b, bor(c, 4294967295-d));
                                    ff=bxor(bb, bxor(cc, dd));
                                end;
                            t=mod(a+f+word[r[j+1]+1]+ka[j+1], 4294967296);
                            t=mod(bor(blshift(t, s[j+1]), brshift(t, 
                                32-s[j+1]))+e, 4294967296);
                            a=e;
                            e=d;
                            d=bor(blshift(c, 10), brshift(c, 22));
                            c=b;
                            b=t;
                            t=mod(aa+ff+word[rr[j+1]+1]+kb[j+1], 4294967296);
                            t=mod(bor(blshift(t, ss[j+1]), brshift(t, 
                                32-ss[j+1]))+ee, 4294967296);
                            aa=ee;
                            ee=dd;
                            dd=bor(blshift(cc, 10), brshift(cc, 22));
                            cc=bb;
                            bb=t;

                            if j=15 then
                                do;
                                    t=b;
                                    b=bb;
                                    bb=t;
                                end;
                            else if j=31 then
                                do;
                                    t=d;
                                    d=dd;
                                    dd=t;
                                end;
                            else if j=47 then
                                do;
                                    t=a;
                                    a=aa;
                                    aa=t;
                                end;
                            else if j=63 then
                                do;
                                    t=c;
                                    c=cc;
                                    cc=t;
                                end;
                            else if j=79 then
                                do;
                                    t=e;
                                    e=ee;
                                    ee=t;
                                end;
                        end;
                        ha=mod(ha+a, 4294967296);
                        hb=mod(hb+b, 4294967296);
                        hc=mod(hc+c, 4294967296);
                        hd=mod(hd+d, 4294967296);
                        he=mod(he+e, 4294967296);
                        hf=mod(hf+aa, 4294967296);
                        hg=mod(hg+bb, 4294967296);
                        hi=mod(hi+cc, 4294967296);
                        hj=mod(hj+dd, 4294967296);
                        hk=mod(hk+ee, 4294967296);

                        /*              put word[*] hex8. '|';*/
                        do j=1 to 16;
                            word[j]=0;
                        end;
                        i+64;
                    end;
                end;
                rc=fclose(iid);
                rc=filename('_rmd320_');
                rmd320=put(left(reverse(input(put(ha, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hb, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hc, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hd, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(he, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hf, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hg, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hi, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hj, hex8.), $hex8.))), 
                    $hex8.) ||put(left(reverse(input(put(hk, hex8.), $hex8.))), 
                    $hex8.);
                call symput("&_cksum_.", rmd320);
            run;

        %end;
    %else
        %do;
            %put ERROR: Check sum type &type. not supported;
            %goto error;
        %end;

    %if %symexist(sum) %then
        %do;
            %put File &file. has &type.=&sum.;
        %end;
    %ref(filename, clear);
    %option(option);
    %return;
%error:
    %ref(filename, clear);
    %option(option);
    %abort;
%mend;