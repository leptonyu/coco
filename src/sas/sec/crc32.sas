%macro sas_sec_crc32(file, _crc32_);
    %local num;
    %let num=32766;

    data _null_;
        if filename('_crc32_', "&file.") then
            do;
                put 'ERROR: file allocate failed!';
                return;
            end;
        array crctable[256] (000000000x 077073096x 0ee0e612cx 0990951bax 
            0076dc419x 0706af48fx 0e963a535x 09e6495a3x 00edb8832x 079dcb8a4x 
            0e0d5e91ex 097d2d988x 009b64c2bx 07eb17cbdx 0e7b82d07x 090bf1d91x 
            01db71064x 06ab020f2x 0f3b97148x 084be41dex 01adad47dx 06ddde4ebx 
            0f4d4b551x 083d385c7x 0136c9856x 0646ba8c0x 0fd62f97ax 08a65c9ecx 
            014015c4fx 063066cd9x 0fa0f3d63x 08d080df5x 03b6e20c8x 04c69105ex 
            0d56041e4x 0a2677172x 03c03e4d1x 04b04d447x 0d20d85fdx 0a50ab56bx 
            035b5a8fax 042b2986cx 0dbbbc9d6x 0acbcf940x 032d86ce3x 045df5c75x 
            0dcd60dcfx 0abd13d59x 026d930acx 051de003ax 0c8d75180x 0bfd06116x 
            021b4f4b5x 056b3c423x 0cfba9599x 0b8bda50fx 02802b89ex 05f058808x 
            0c60cd9b2x 0b10be924x 02f6f7c87x 058684c11x 0c1611dabx 0b6662d3dx 
            076dc4190x 001db7106x 098d220bcx 0efd5102ax 071b18589x 006b6b51fx 
            09fbfe4a5x 0e8b8d433x 07807c9a2x 00f00f934x 09609a88ex 0e10e9818x 
            07f6a0dbbx 0086d3d2dx 091646c97x 0e6635c01x 06b6b51f4x 01c6c6162x 
            0856530d8x 0f262004ex 06c0695edx 01b01a57bx 08208f4c1x 0f50fc457x 
            065b0d9c6x 012b7e950x 08bbeb8eax 0fcb9887cx 062dd1ddfx 015da2d49x 
            08cd37cf3x 0fbd44c65x 04db26158x 03ab551cex 0a3bc0074x 0d4bb30e2x 
            04adfa541x 03dd895d7x 0a4d1c46dx 0d3d6f4fbx 04369e96ax 0346ed9fcx 
            0ad678846x 0da60b8d0x 044042d73x 033031de5x 0aa0a4c5fx 0dd0d7cc9x 
            05005713cx 0270241aax 0be0b1010x 0c90c2086x 05768b525x 0206f85b3x 
            0b966d409x 0ce61e49fx 05edef90ex 029d9c998x 0b0d09822x 0c7d7a8b4x 
            059b33d17x 02eb40d81x 0b7bd5c3bx 0c0ba6cadx 0edb88320x 09abfb3b6x 
            003b6e20cx 074b1d29ax 0ead54739x 09dd277afx 004db2615x 073dc1683x 
            0e3630b12x 094643b84x 00d6d6a3ex 07a6a5aa8x 0e40ecf0bx 09309ff9dx 
            00a00ae27x 07d079eb1x 0f00f9344x 08708a3d2x 01e01f268x 06906c2fex 
            0f762575dx 0806567cbx 0196c3671x 06e6b06e7x 0fed41b76x 089d32be0x 
            010da7a5ax 067dd4accx 0f9b9df6fx 08ebeeff9x 017b7be43x 060b08ed5x 
            0d6d6a3e8x 0a1d1937ex 038d8c2c4x 04fdff252x 0d1bb67f1x 0a6bc5767x 
            03fb506ddx 048b2364bx 0d80d2bdax 0af0a1b4cx 036034af6x 041047a60x 
            0df60efc3x 0a867df55x 0316e8eefx 04669be79x 0cb61b38cx 0bc66831ax 
            0256fd2a0x 05268e236x 0cc0c7795x 0bb0b4703x 0220216b9x 05505262fx 
            0c5ba3bbex 0b2bd0b28x 02bb45a92x 05cb36a04x 0c2d7ffa7x 0b5d0cf31x 
            02cd99e8bx 05bdeae1dx 09b64c2b0x 0ec63f226x 0756aa39cx 0026d930ax 
            09c0906a9x 0eb0e363fx 072076785x 005005713x 095bf4a82x 0e2b87a14x 
            07bb12baex 00cb61b38x 092d28e9bx 0e5d5be0dx 07cdcefb7x 00bdbdf21x 
            086d3d2d4x 0f1d4e242x 068ddb3f8x 01fda836ex 081be16cdx 0f6b9265bx 
            06fb077e1x 018b74777x 088085ae6x 0ff0f6a70x 066063bcax 011010b5cx 
            08f659effx 0f862ae69x 0616bffd3x 0166ccf45x 0a00ae278x 0d70dd2eex 
            04e048354x 03903b3c2x 0a7672661x 0d06016f7x 04969474dx 03e6e77dbx 
            0aed16a4ax 0d9d65adcx 040df0b66x 037d83bf0x 0a9bcae53x 0debb9ec5x 
            047b2cf7fx 030b5ffe9x 0bdbdf21cx 0cabac28ax 053b39330x 024b4a3a6x 
            0bad03605x 0cdd70693x 054de5729x 023d967bfx 0b3667a2ex 0c4614ab8x 
            05d681b02x 02a6f2b94x 0b40bbe37x 0c30c8ea1x 05a05df1bx 02d02ef8dx);
        ha=0ffffffffx;
        length byte $&num.. crc32 $8.;
        iid=fopen('_crc32_', 'i', &num., 'b');
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
        rc=filename('_crc32_');
        crc32=put(bnot(ha), hex8.);

        if compress("&_crc32_.")='' then
            do;
                put 'File ' "&file." ' has ' n 'bytes.';
                put crc32=;
            end;
        else if symexist("&_crc32_.") then
            call symput("&_crc32_.", crc32);
        else
            do;
                rc=filename('crc32__', "&file..crc32");
                oid=fopen('crc32__', 'o', 8, 'b');
                rc=fput(oid, crc32);
                rc=fwrite(oid);
                rc=fclose(oid);
                rc=filename('crc32__');
            end;
    run;

%mend;