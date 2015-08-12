/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-08-12 00:02:27
* @version 1.0
* 
*************************************************/
 
%macro printstack(message,abort=1);
	%local depth len;
	%let depth=%sysmexecdepth;
	%if %length(&message.) %then %do;
		%put ERROR: &message.;
	%end;
	%do %while(&depth.>0);
		%let depth=%eval(&depth.-1);
		%put ERROR: +&len.>[&depth.] %sysmexecname(&depth.);
		%let len=&len.-;
	%end;
	%if "&abort."="1" %then %do;
		%abort;
	%end;
%mend;
