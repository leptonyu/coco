%import(sas_sec_cksum);

%sas_sec_cksum(type=crc32);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=crc32);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=crc32);

%sas_sec_cksum(type=md5);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=md5);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=md5);

%sas_sec_cksum(type=sha1);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=sha1);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=sha1);

%sas_sec_cksum(type=sha224);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=sha224);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=sha224);

%sas_sec_cksum(type=sha256);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=sha256);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=sha256);

%sas_sec_cksum(type=ripemd128);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=ripemd128);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=ripemd128);

%sas_sec_cksum(type=ripemd160);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=ripemd160);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=ripemd160);

%sas_sec_cksum(type=ripemd256);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=ripemd256);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=ripemd256);

%sas_sec_cksum(type=ripemd320);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=ripemd320);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=ripemd320);

%sas_sec_cksum(type=not);
%sas_sec_cksum(&g_src.sas/lang/import.saks,type=not);
%sas_sec_cksum(&g_src.sas/lang/import.sas,type=not);