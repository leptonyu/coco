# coco

## Overview
***coco***, a *sas* library for *SAS University Edition* and *SAS Studio*. ***coco*** provides many sas macros to support a lot of features, such as code organization, smart import sas macros, test suites for test macros, source code folder management. To use coco, you should follow some principals.

### Principals
1. coco source code file must contain one and only one macro definition, only macro %import could be used outside the macro body, no open code should be written in the source file.

	``` 
   /**
   To tell user what this macro do.
   @author Daniel YU
   @since 2015-4-6
   */
   
   %import(nvalid);
   
   %macro yourmacro(parameter);
     %*do something using %nvalid;
   %mend;

	```

2. Global macro variables should always be named with prefix g_, and local macro variables should never do this. Both global and local macro variables must declare before use.
3. Try to avoid creating new global macro variables, always using local macro variables.

### Installation
***coco*** support SAS 9.4+, with SAS University Edition and SAS Studio. 

1. Install the [SAS University Edition](http://www.sas.com/en_us/software/university-edition.html)
2. Download coco project to your computer.

	```
		git clone git@github.com:leptonyu/coco.git
	```
3. Mount coco project folder as named myfolders to virtual machine.

![coco_desc](https://raw.githubusercontent.com/leptonyu/coco/develop/src/coco_desc.png)
 
 
  