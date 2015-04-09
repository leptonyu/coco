%*Please write test code here;;
%*ismacroref();
%global xxxx;
%asserteq(1,%ismacroref(xxxx));
%symdel xxxx;
%asserteq(0,%ismacroref(xxxx));
%asserteq(0,%ismacroref());
%asserteq(0,%ismacroref(00));