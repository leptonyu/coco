%asserteq(1,%hassuffix(abc,abc));
%asserteq(1,%hassuffix(abc,c));

%asserteq(0,%hassuffix(abc,a));
%asserteq(1,%hassuffix());
%asserteq(1,%hassuffix(,));
%asserteq(0,%hassuffix(,a));
%asserteq(1,%hassuffix(a,));
