/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-08-12 17:20:00
* @version 1.0
* 
*************************************************/

%import(newmacro);

%macro new(name);
	%newmacro(&name., srcid=1);
%mend;
