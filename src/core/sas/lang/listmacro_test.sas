%global rc;
%listmacro(id=);
%let rc=&sysrc.;
%asserteq(0,&rc.);
%listmacro(id=9);
%let rc=&sysrc.;
%asserteq(0,&rc.);
%symdel rc;