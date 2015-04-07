%global src;
%let src=&g_src.sas&g_.lang&g_.;
%asserteq(,%getpath());
%asserteq(,%getpath(.));
%asserteq(,%getpath(.l));
%asserteq(,%getpath(l.));
%asserteq(,%getpath(%str( )));
%asserteq(&src.import.sas,%getpath(import));
%asserteq(&g_src.sas&g_.sec&g_.cksum.sas,%getpath(sec.cksum));