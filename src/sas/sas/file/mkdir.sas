%macro sas_file_mkdir(dir);
    data _null_;
        length dir $256 dir2 $256 name $64;
        dir=symget('dir');
        dir2=symget('dir');

        if prxmatch('/[a-z]:(\\[^\\]+)+\\?/i', dir) then
            do;

                if not fileexist(dir) then
                    do;
                        dir=scan(dir, 1, '\')||'\';
                        i=2;
                        name=scan(dir2, i, '\');

                        do while(dir^='' and name^='');

                            if not fileexist(trim(dir)||trim(name)) then
                                dir=dcreate(name, dir)||'\';
                            else
                                dir=trim(dir)||trim(name)||'\';
                            i+1;
                            name=scan(dir2, i, '\');
                        end;
                    end;
            end;

        if dir='' then
            put 'ERROR: Directory ' dir2 ' create failed!';
        else
            put 'NOTE: Directory ' dir ' successfully created!';
    run;

%mend;