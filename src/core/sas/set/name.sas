/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-24 14:34:07
 * @version 1.0
 * @desp    get datasets name.
 *************************************************/
 
%import(nvalid);
 
%macro sas_set_name(datasetname);
    %if %sysfunc(count("&datasetname.", .))=1 %then
        %do;
            %let datasetname=%lowcase(%scan(&datasetname., 2, .));
        %end;
    %if not %nvalid(&datasetname.) %then
        %do;
            %let datasetname=;
        %end;
    &datasetname.
%mend;
