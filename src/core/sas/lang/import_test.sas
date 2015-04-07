%import();
%import(import);
%import(IMPORT);
%sysmacdelete option;
%asserteq(0,%sysmacexist(option));
%import(OPTION);
%asserteq(1,%sysmacexist(option));

%import(testprint);

%testprint;
