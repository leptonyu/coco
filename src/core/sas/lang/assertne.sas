/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-09 09:32:34
* @version 1.0
* 
*************************************************/

%import(printstack);

%macro assertne(expected, actual);
    %if "%superq(expected)" eq "%superq(actual)" %then
        %do;
        	%put _LOCAL_;
			%printstack(Value "%superq(actual)" was NOT excepted to be "%superq(expected)");
        %end;
    %put NOTE: <%superq(expected)> NOT equals <%superq(actual)>!;
%mend;