/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-26 09:42:00
* @version 1.0
* 
*************************************************/

%import(sas_map_name);

%macro sas_map_new();
   %local var i;
   %let i=0;
   %do %while(&i. < 4294967296 );
      %let var=%sas_map_name(&i.);
      %if not %symexist(&var.) %then %do;
        %goto exit;
      %end;
      %let i=%eval(&i.+1);
   %end;
   %put ERROR: Map locate overflow!;
   %return;
%exit:
   %if not %symexist(g_sas_map) %then %do;
      %global g_sas_map;
      %let g_sas_map=&i.;
   %end;%else %if &g_sas_map.<&i. %then %do;
      %let g_sas_map=&i.;
   %end;
   %global &var.;
   %put NOTE: new Map &var. ();
   &var.
%mend;
