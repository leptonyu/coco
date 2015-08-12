/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-28 11:27:57
* @version 1.0
* @desp    support parse list comprehensions.
*************************************************/

%import(sas_str_ref);
%import(sas_str_register);
%import(sas_list_push);

%macro sas_list_new/parmbuff;
    %local ref rc;
    %let ref=%sas_str_ref();
    %let rc=%sas_str_register(&ref.);
    &ref.
    %let rc=%sysfunc(prxparse(/\(\[(.*)\]\)/));
    %if %sysfunc(prxmatch(&rc.,%superq(syspbuff))) %then %do;
    	%let rc=%sysfunc(prxposn(&rc.,1,%superq(syspbuff)));
    	%local var i fake;
    	%let i=1;
    	%let var=%scan(%nrquote(&rc.),&i.,%nrstr(,));
    	%do %while(%length(&var.));
    		%let fake=%sas_list_push(&ref.,&var.);
    		%let i=%eval(&i.+1);
    		%let var=%scan(%nrquote(&rc.),&i.,%nrstr(,));
    	%end;
    %end;
%mend;
