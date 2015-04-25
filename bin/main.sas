%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;
%sh(
{
sort "s f els f d d oooo dd" 'uniq=1';
sort 'hello sss s pp0' 
}
abc="$";
put "abc=" "$abc.";
{sort "$abc ddd" }
abc="$";
put "abc=" "$abc.";
);