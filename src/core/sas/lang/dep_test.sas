%dep();
%dep(import);
%dep(dep);
%dep(test);


%dep(sh);
%dep(f.mkdir);

%global hello;
%dep(dep,hello);
%asserteq(dep,&hello.);
