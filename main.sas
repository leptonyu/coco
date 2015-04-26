%inc "&_SASWS_./autoexec.sas";
%let g_sh_openlog=1;

%sh(
refxxx=;
ref "#refxxx";
put "$refxxx";
{getpath import}
parsemacro "$" "$refxxx";
print "$refxxx";
ref "#refxxx" clear;
);
