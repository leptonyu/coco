%global rc;

%test(,rc);
%asserteq(0,&rc.);

%test(.,rc);
%asserteq(0,&rc.);

%test(import,rc);
%asserteq(1,&rc.);

%symdel rc;