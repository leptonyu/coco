/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 13:23:06
* @version 1.0
* 
*************************************************/

%import(sas_list_string);

%macro sas_list_tostr(list_ref);
   %let list_ref=%sas_list_string(&list_ref.);
   %local str i v;
   %let i=1;
   %let v=%scan(&list_ref.,&i.,|);
   %do %while("&v."^="");
      %if &i.>1 %then %do;
         %let str=%superq(str),;
      %end;
      %if %symexist(g_sas_pool_&v.) %then %do;
          %let str=%superq(str)%superq(g_sas_pool_&v.);
      %end;
      %let i=%eval(&i.+1);
      %let v=%scan(&list_ref.,&i.,|);
   %end;
   [%superq(str)]
%mend;
