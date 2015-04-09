/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%macro assertne(expected, actual);
    %if "&expected."="&actual." %then
        %do;
            %put ERROR: Value "&actual." was NOT excepted to be "&expected." ;
            %put _LOCAL_;
            %abort;
        %end;
    %put NOTE: <&expected.> NOT equals <&actual.>!;
%mend;