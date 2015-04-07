%asserteq(1,%hasprefix(abc,a));
%asserteq(1,%hasprefix(abc,abc));


%asserteq(0,%hasprefix(abc,c));
%asserteq(1,%hasprefix());
%asserteq(1,%hasprefix(,));
%asserteq(1,%hasprefix(q,));
%asserteq(0,%hasprefix(,q));