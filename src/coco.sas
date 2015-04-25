/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro __init_coco__;

    %if &sysver. < 9.4 %then
        %do;
            %put ERROR: SAS &sysver. not supported by coco.;
            %abort;
        %end;
    %global g_ g_src;
    %* create global path;
    %let g_=/;
    %let g_src=&_SASWS_.&g_.src&g_.core&g_.;
    ;
    %local srclang;
    %let srclang=&g_src.sas&g_.lang&g_.;
    ;
    %*let g_src_1=;
    %* ...;
    %*let g_src_8=;
    %global g_src_9;
    %let g_src_9=&_SASWS_./src/test/;
    ;
    %* create handler pointer;
    %global g_handler_f;
    %let g_handler_f=sas_file_;
    %global g_handler_log;
    %let g_handler_log=sas_log_;
    %global g_handler_l;
    %let g_handler_l=sas_log_;
    %global g_handler_sec;
    %let g_handler_sec=sas_sec_;
    %global g_handler_str;
    %let g_handler_str=sas_str_;
    %global g_handler_set;
    %let g_handler_set=sas_set_;
    %global g_handler_lib;
    %let g_handler_lib=sas_lib_;
    %* import fundamental macros.;
    ;
    
    %if not %symexist(g_debug) %then %do;
      %global g_debug;
      %let g_debug=0;
    %end;
    
    %inc "&srclang.nvalid.sas";
    %inc "&srclang.canonicalname.sas";
    %inc "&srclang.getpath.sas";
    %inc "&srclang.import.sas";
%mend;

%__init_coco__;

%sysmacdelete __init_coco__;
%* using import to import core macros.;
%* This part canbe modified;
%import(sh);
%import(test);