%macro sas_sec_rc4decrypt(file, password);
    filename _rc4_ temp;

    data _null_;
        length pwd $256;
        file _rc4_;
        pwd=compress("&password.");
        put pwd;
    run;

    %local password pwdarray;
    %sdk_secure_hash_sha256(%sysfunc(pathname(_rc4_)), password);
    filename _rc4_ clear;

    /*	%put &password.;*/

	%let pwdarray=%str();

    %do i=1 %to 64 %by 2;
        %let pwdarray=&pwdarray. 0%substr(&password., &i., 2)x;
    %end;
    %local num;
    %let num=16386;

    data _null_;
        if filename('_rc4', "&file..rc4") then
            do;
                put 'error: 找不到加密文件!';
                return;
            end;

        if fileexist("&file.") then
            do;
                put 'error: 有重名文件存在，解码过程中止！';
                return;
            end;
        else
            rc=filename('rc4_', "&file.");
        array s[256];
        array key[32] (&pwdarray.);

        do i=0 to 255;
            s[i+1]=i;
        end;
        j=0;

        do i=0 to 255;
            j=mod(j+s[i+1]+key[mod(i, 32)+1], 256);
            temp=s[i+1];
            s[i+1]=s[j+1];
            s[j+1]=temp;
        end;

        /*		put s[*];*/
        /*		put key[*] hex2.;*/
        length byte $&num.;
        iid=fopen('_rc4', 'i', &num., 'b');
        oid=fopen('rc4_', 'o', &num., 'b');
        n=0;
        i=0;
        j=0;

        do while(fread(iid)=0);
            length=frlen(iid);
            n+length;
            rc=fget(iid, byte, length);
            k=0;

            do while(k<length);
                k+1;
                i=mod(i+1, 256);
                j=mod(j+s[i+1], 256);
                temp=s[i+1];
                s[i+1]=s[j+1];
                s[j+1]=temp;
                substr(byte, k, 1)=byte(bxor(rank(char(byte, k)), 
                    s[mod(s[i+1]+s[j+1], 256)+1]));
            end;

            if length<&num. then
                rc=fput(oid, substr(byte, 1, length));
            else
                rc=fput(oid, byte);
            rc=fwrite(oid);
        end;
        rc=fclose(iid);
        rc=filename('_rc4');
        rc=fclose(oid);
        rc=filename('rc4_');
    run;

%mend;