%asserteq(a b c,%sort(b a c));
%asserteq(a b c,%sort(a b c));
%asserteq(a b c,%sort(c b a));


%asserteq(,%sort());
%asserteq(,%sort(   ));
%asserteq(a,%sort(  a ));


%asserteq(a b c c,%sort(c b a c));
%asserteq(a b c,%sort(c b a c,uniq=1));


%assertne(a b c,%sort(c ba));
%assertne(a b c,%sort(c));
%assertne(a b c,%sort());
