coco
===========
A *sas* library for *SAS University Edition* and *SAS Studio*. 

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/leptonyu/coco/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## Overview
***coco*** provides many sas macros to support a lot of features, such as code organization, smart import sas macros, test suites for test macros, source code folder management. To use coco, you should follow some principals.

### Principals
1. coco source code file must contain one and only one macro definition, only macro %import could be used outside the macro body, no open code should be written in the source file. 

	``` 
   /**
   To tell user what this macro do.
   @author Daniel YU
   @since 2015-4-6
   */
   
   %import(nvalid);
   
   /*
   the source file should put in source folder as your/macro.sas 
   */
   
   %macro your_macro(parameter);
     %*do something using %nvalid;
   %mend;

	```
	Macro names define the source file name and its path in the source folders. We replace underscore(_) as path seperator(/) to macro name, for example, 
	
	```
		your_macro --> your/macro.sas 
		macro --> macro.sas
		import --> sas/lang/import.sas
		
	```
	Last line show that sas/lang/ folder is considered as a special source folder, and macro names like sas_lang_xx never existing in ***coco***.

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

4. When you see coco files in My Folders like in the pic, then coco is installed complete.
5. open bin/main.sas, write your own call code using coco.
6. open bin/testCoco.sas and run to test coco works on your platform.

### Source Folders of ***coco***
***coco*** can have 10 source folders. The main source folder used by ***coco*** source is defined in global macro variable g_src. Developers should not put your own sources in this folder.

***coco*** use 9 global macro variables named from g_src_1 to g_src_9 to define the extended source folder. if you can add your own source folder in to ***coco*** source path by set any of these 9 global macro variable. 


### Core ***coco*** Macro

#### %import(name)
This is the core macro of ***coco***, its implementation is based on the principals described above. It is used to import coco source files.  

#### %test(name)
This macro provides the test suite for ***coco*** macros. It runs the test of the given macro. And the test file should in the same folder as the given macro, and the name of test file should add suffix _test. For example, the test file of macro %import is import_test.sas, while its source file is import.sas. This is motivated golang.

#### %sh(code)
It's a ***coco*** script interpreter runner. It can be used to simplify the code of using ***coco*** library.

##### Examples:

```
1. simplify import.

%sh(help);
--->
%import(help);
%help();

2. create variables.
%sh(
var=f.list;
help "$var";
);
--->
%let g__var=f.list;
%import(help);
%help(&g__var);

%sh(
name=Daniel;
put "Hello, I'm $name" ;
);
-->
%let g__name=Daniel;
%put Hello, I'm &g__name;

3. simplify macro invoke.
%sh(
method "p1" p2 "p 3";
);
-->
%import(method);
%method(p1,p2,p 3);

%sh(
method p1 p2 p3;
);
-->
%import(method);
%method(p1,p2,p3);

```

#### %help(name)
Print help infomation for specific macro, for example:

```
%help(help);

logout:
+-HELP help---------------------------------------------------------------------+
| name       help                                                               |
| path       /folders/myfolders/src/core/sas/lang/help.sas                      |
| dep        canonicalname                    dep                               |
|            getpath                          listmacro                         |
|            option                           sort                              |
+-------------------------------------------------------------------------------+
| author     Daniel YU                                                          |
| since      2015-04-24 23:30:06                                                |
| version    1.0                                                                |
| desp       get help of macro                                                  |
+------------------------------------------------------------Designed by Daniel-+
```
If name is empty then print all macros exist in ***coco***:

```
%help();

logout:
 +-LIST coco Macros--------------------------------------------------------------+
 | 1          asserteq                                                           |
 | 2          assertne                                                           |
 | 3          assertref                                                          |
 | 4          canonicalname                                                      |
 | 5          dep                                                                |
 | 6          getpath                                                            |
 | 7          hasprefix                                                          |
 | 8          hassuffix                                                          |
 | 9          help                                                               |
 | 10         import                                                             |
~~~~~~~~~~~~~~~ ignore some logs.
 | 48         validate                                                           |
 +------------------------------------------------------------Designed by Daniel-+
```


### Author
Daniel YU (http://icymint.me)
 
 
