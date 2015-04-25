/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* @desp    list items in a folder.
*************************************************/

%import(hassuffix);

%macro sas_file_list(dir, _lst_, suffix=);
    %local option flag;
    %option(option);
    %let flag=0;
    %if not %ismacroref(&_lst_.) %then
        %do;
            %local lst;
            %let _lst_=lst;
            %let flag=1;
        %end;

    %macro _sas_file_list(d, path);
        %local fref;
        %let fref=&d.&path.;
        %ref(fref);

        %if "__err"="&fref." %then
            %return;
        %local did;
        %let did=%sysfunc(dopen(&fref.));

        %if &did.=0 %then
            %goto _exit;
        %local i rc entry;

        %do i=1 %to %sysfunc(dnum(&did.));
            %let entry=%sysfunc(dread(&did., &i.));

            %if %hassuffix(&entry., &suffix.) %then
                %do;
                    %let &_lst_.=&&&_lst_.. &path.&entry.;
                %end;
            %_sas_file_list(&d., &path.&entry.&g_.);
        %end;
        %let rc=%sysfunc(dclose(&did.));
%_exit:
        %ref(fref, clear);
    %mend;

    %_sas_file_list(&dir., );
    %sysmacdelete _sas_file_list;

    %if &flag. %then
        %do;
            %put &&&_lst_.;
        %end;
%exit:
    %option(option);
%mend;