/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-24 14:26:08
 * @version 1.0
 *
 *************************************************/
 
%import(nvalid);

%macro sas_lib_name(datasetname);
    %if %index("&datasetname.", .) %then
        %do;
            %let datasetname=%lowcase(%scan(&datasetname., 1, .));

            %if not %nvalid(&datasetname.) %then
                %do;
                    %let datasetname=work;
                %end;
        %end;
    %else
        %do;
            %let datasetname=work;
        %end;
    &datasetname.
%mend;