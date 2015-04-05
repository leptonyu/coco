%macro sas_file_list(dir, _lst_);
    options nonotes nosource;

    data _null_;
        length lst $32767 name $128;
        rc=filename("_dir_", symget('dir'));
        did=dopen("_dir_");
        lst='';

        if did then
            do;

                do i=1 to dnum(did);
                    name=scan(dread(did, i), 1);
                    lst=compbl(trim(lst)||' '||name);
                end;
                rc=dclose(did);

                if compress("&_lst_.")^='' then
                    call symput("&_lst_.", trim(lst));
            end;
        else
            put "ERROR: Directory &dir. not exist!";
        rc=filename("_dir_");
    run;

    options notes source;
%mend;