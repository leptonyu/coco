/*************************************************
 * Copyright(c) 2015 coco, All Rights Reserved.
 * @author  Daniel YU
 * @since   2015-04-09 09:32:34
 * @version 1.0
 * can not work
 *
 *************************************************/
 
 
%macro sas_file_mkdir(dir);
    data _null_;
        length dir $256 dir2 $256 name $64;
        dir=symget('dir');
        if prxmatch('/(\/[^\/]+)+\/?/i', trim(dir)) then
            do;
                if not fileexist(dir) then
                    do;
                        i=1;
                        name=scan(dir, i, '/');
                        dir2='/'||trim(name);
                        do while(name^='');
                            if not fileexist(dir2) then do;
                              put dir2=;
                              dir2=dcreate(trim(name),trim(dir2)||'/');
                              put dir2=;
                            end;
                            i+1;
                            name=scan(dir, i, '/');
                            dir2=trim(dir2)||'/'||trim(name);
                        end;
                    end;
            end;

        if dir2='' then
            put 'ERROR: Directory ' dir ' create failed!';
        else
            put 'NOTE: Directory ' dir ' successfully created!';
    run;

%mend;