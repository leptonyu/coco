/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro sas_set_nobs(fins,_nobs_);
	data _null_;
		length table $41;
		nobs=0;
		i=1;table=scan("&fins.",i,' ');
		do while(compress(table)^='');
			dsid=open(table);
			if dsid then do;
				nobs+attrn(dsid,'nobs');
				rc=close(dsid);
			end;else put 'ERROR: Dataset ' table ' not exist!';
			i+1;table=scan("&fins.",i,' ');
		end;
		call symput("&_nobs_.",compress(put(nobs,8.)));
	run;
%mend;