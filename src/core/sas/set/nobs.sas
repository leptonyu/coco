/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* @desp    get datasets total nobs.
*************************************************/

%import(sas_set_name);
%import(sas_lib_name);

%macro sas_set_nobs(fins);
  %local fin i fid rc name nobs;
  %let nobs=0;
  %let i=1;
  %let fin=%scan(&fins.,&i.,%str( ));
  %do %while("&fin."^="");
      %let name=%sas_set_name(&fin.);
      %if "&name."^="" %then %do;
        %let fin=%sas_lib_name(&fin.).&name.;
        %let fid=%sysfunc(open(&fin.));
        %if &fid. %then %do;
          %let nobs=%eval(&nobs.+%sysfunc(attrn(&fid.,nobs)));
          %let rc=%sysfunc(close(&fid.));
        %end;
      %end;
      %let i=%eval(&i.+1);
      %let fin=%scan(&fins.,&i.,%str( ));
  %end;
	&nobs.
%mend;