/*************************************************
* Copyright(c) 2015 coco, All Rights Reserved.
* @author  Daniel YU
* @since   2015-04-24 22:52:38
* @version 1.0
* 
*************************************************/

%import(ismacroref);

%macro validate(______var_______,_______localvars________);
  %if not %ismacroref(&______var_______.) %then %do;
    %put WARNING: <&______var_______.> is not a valid macro;
    %let ______var_______=0;
    %goto exit;
  %end;
  %let ______var_______=1;
  %local var;
  %let var=%lowcase(&______var_______.);
  %local i v;
  %let i=1;
  %let v=%lowcase(%scan(&_______localvars________.,&i.,%str( )));
  %do %while(""^="&v.");
    %if "&v."="&var." %then %do;
      %put ERROR: local variable conflict, must not pass <&var.> in this macro!;
      %abort;
    %end;
    %let i=%eval(&i.+1);
    %let v=%lowcase(%scan(&_______localvars________.,&i.,%str( )));
  %end;
  %exit:
  &______var_______.
%mend;
