%global rc;
%listmacro(id=);
%let rc=&sysrc.;
%asserteq(0,&rc.);
%listmacro(id=9);
%let rc=&sysrc.;
%asserteq(0,&rc.);
%symdel rc;

%global lst;
%listmacro(lst);
%put &lst;
%put ------;
%let lst=;
%listmacro(lst,id=0);
%put &lst;
%symdel lst;
