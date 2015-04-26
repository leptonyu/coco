/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-26 09:48:43
* @version 1.0
* 
*************************************************/

%import(ismacroref);
%import(hasprefix);

%macro sas_map_del(map);
    %local i j;
    %let i=1;
    %let j=%scan(&map., &i., %str( ));
    %do %while("&j."^="");
        %if %ismacroref(&j.) and %hasprefix(&j.,g_sas_map_) %then %do;
            %put NOTE: delete Map &j. = &&&j..;
            %symdel &j.;
        %end;
        %let i=%eval(&i.+1);
        %let j=%scan(&map., &i., %str( ));
    %end;
%mend;
