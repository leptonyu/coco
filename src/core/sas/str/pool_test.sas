%*Please write test code here;;
%*%asserteq( ,%sas_str_pool());
%*%assertne( ,%sas_str_pool());
%*%assertref( );


%put %sas_str_pool();
%put %sas_str_pool(a);
%put %sas_str_pool(b);
%put %sas_str_pool(c);
%put %sas_str_pool(d);
%put %sas_str_pool(e);
%put %sas_str_pool(f);
%put %sas_str_pool(g);
%put %sas_str_pool(h);
%put %sas_str_pool(i);
%put %sas_str_pool(j);
%put %sas_str_pool(k);
%put %sas_str_pool(l);
%put %sas_str_pool(m);
%put %sas_str_pool(n);
%put %sas_str_pool(o);
%put %sas_str_pool(p);
%put %sas_str_pool(q);
%put %sas_str_pool(r);
%put %sas_str_pool(s);
%put %sas_str_pool(t);
%put %sas_str_pool(u);
%put %sas_str_pool(v);
%put %sas_str_pool(w);
%put %sas_str_pool(x);
%put %sas_str_pool(y);
%put %sas_str_pool(z);

%global t;
%let t=%sas_str_pool(zzz);
%asserteq(&t.,%sas_str_pool(zzz));
%asserteq(&t.,%sas_str_pool(zzz));
%asserteq(&t.,%sas_str_pool(zzz));
%asserteq(&t.,%sas_str_pool(zzz));
%asserteq(&t.,%sas_str_pool(zzz));
%asserteq(&t.,%sas_str_pool(zzz));
%symdel t;

%macro _test(num);
   %local i v;
   %do i=1 %to &num.;
      %let v=%sas_str_pool(&i.);
   %end;
%mend;

%_test(10);
%sysmacdelete _test;

%import(sas_str_gc);
%sas_str_gc();

%put _all_;