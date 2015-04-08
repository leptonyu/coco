%dep();
%dep(import);
%dep(dep);
%dep(test);


%dep(sh);
%dep(f.mkdir);
%dep(canonicalname);

%global hello;
%dep(nvalid,hello);
%asserteq(,&hello.);
%symdel hello;
