%asserteq(,%canonicalname());
%asserteq(,%canonicalname( ));
%asserteq(namename,%canonicalname(name name));
%asserteq(xxx,%canonicalname(XXX));
%asserteq(xx,%canonicalname(sas_lang_xx));
%asserteq(abc,%canonicalname(SAS_LANG_ABC));

%asserteq(sas_log_abc,%canonicalname(l.abc));
%asserteq(sas_log_abc,%canonicalname(log.abc));
%asserteq(sas_file_abc,%canonicalname(f.abc));


%asserteq(,%canonicalname(never.abc));