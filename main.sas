%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;
%sh({
list.new;
}
abc="$"
{
list.push "$abc" 'hhh "o 中文1';
list.push "$abc" 'hhh "o 中文2';
list.push "$abc" 'hhh "o 中文3';
list.push "$abc" 'hhh "o 中文4';
list.push "$abc" 'hhh "o 中文5';
list.string "$abc";
list.pop "$abc";
}
);