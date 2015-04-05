%macro sas_sec_sha224(file, _sha224_);
    %local num;
    %let num=510;

    data _null_;
        if filename('_sha224_', "&file.") then
            do;
                put 'error: 文件分配错误!';
                return;
            end;
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
        array kk[64] (0428a2f98x 071374491x 0b5c0fbcfx 0e9b5dba5x 03956c25bx 
            059f111f1x 0923f82a4x 0ab1c5ed5x 0d807aa98x 012835b01x 0243185bex 
            0550c7dc3x 072be5d74x 080deb1fex 09bdc06a7x 0c19bf174x 0e49b69c1x 
            0efbe4786x 00fc19dc6x 0240ca1ccx 02de92c6fx 04a7484aax 05cb0a9dcx 
            076f988dax 0983e5152x 0a831c66dx 0b00327c8x 0bf597fc7x 0c6e00bf3x 
            0d5a79147x 006ca6351x 014292967x 027b70a85x 02e1b2138x 04d2c6dfcx 
            053380d13x 0650a7354x 0766a0abbx 081c2c92ex 092722c85x 0a2bfe8a1x 
            0a81a664bx 0c24b8b70x 0c76c51a3x 0d192e819x 0d6990624x 0f40e3585x 
            0106aa070x 019a4c116x 01e376c08x 02748774cx 034b0bcb5x 0391c0cb3x 
            04ed8aa4ax 05b9cca4fx 0682e6ff3x 0748f82eex 078a5636fx 084c87814x 
            08cc70208x 090befffax 0a4506cebx 0bef9a3f7x 0c67178f2x);
        length=64*&num.;
        iid=fopen('_sha224_', 'i', length, 'b');
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
                                                word[15]=int(n*8/4294967296);
                                                word[16]=mod(n*8, 4294967296);
                                                flg=0;
                                            end;
                                        else if flg=0 then
                                            flg=1;

                                        /*							put k= flg=;*/
                                    end;
                            end;
                    end;

                do j=17 to 64;
                    word[j]=mod(word[j-16]+word[j-7]
						   +bxor(bxor(bor(blshift(word[j-15], 25), brshift(word[j-15], 
                        7)) , bor(blshift(word[j-15], 14), brshift(word[j-15], 
                        18))) , brshift(word[j-15], 3)) 
                        +bxor(bxor(bor(blshift(word[j- 2], 15), 
                        brshift(word[j- 2], 17)) , bor(blshift(word[j- 2], 13), 
                        brshift(word[j- 2], 19))) , brshift(word[j- 2], 10)) , 
                        4294967296);
                end;

                /*				put word[*] hex8.;*/
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

                    /*				put j= @10 a hex8. '|' b hex8. '|' c hex8. '|' d hex8. '|' e hex8. '|' f hex8. '|' g hex8. '|' h hex8.;*/
                    tb=bxor(bxor(bor(blshift(a, 30), brshift(a, 2)) , 
                        bor(blshift(a, 19), brshift(a, 13))) , bor(blshift(a, 
                        10), brshift(a, 22))) +bxor(bxor(band(a, b), band(a, 
                        c)), band(b, c));
                    ta=h+kk[j]+word[j]
					  +bxor(bxor(bor(blshift(e, 26), brshift(e, 6)) , bor(blshift(e, 
                        21), brshift(e, 11))) , bor(blshift(e, 7), brshift(e, 
                        25))) +bxor(band(e, f), band(4294967295-e, g));
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

        if compress("&_sha224_.")='' then
            do;
                put '文件' "&file." '字节数为' n 'bytes.';
                put sha224=;
            end;
        else if symexist("&_sha224_.") then
            call symput("&_sha224_.", sha224);
        else
            do;
                rc=filename('sha224__', "&file..sha224");
                oid=fopen('sha224__', 'o', 56, 'b');
                rc=fput(oid, sha224);
                rc=fwrite(oid);
                rc=fclose(oid);
                rc=filename('sha224__');
            end;
    run;

%mend;