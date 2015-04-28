%*Please write test code here;;
%*%asserteq( ,%sas_list_push());
%*%assertne( ,%sas_list_push());
%*%assertref( );
%sh({
list.new;
}
abc="$"
{
list.push "$abc" hello;
list.string "$abc";
list.push "$abc" nihao;
list.string "$abc";
list.push "$abc" nihao;
list.string "$abc";
list.pop "$abc";
asserteq nihao "$";
list.string "$abc";
list.pop "$abc";
asserteq nihao "$";
list.string "$abc";
list.pop "$abc";
asserteq hello "$";
list.string "$abc";
}
);