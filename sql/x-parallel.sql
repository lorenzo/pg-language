

DO $$
DECLARE version_num integer;
BEGIN
  SELECT current_setting('server_version_num') INTO STRICT version_num;
  IF version_num > 90600 THEN
	EXECUTE $E$ ALTER FUNCTION spoken_lang_in(cstring) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_out(spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_recv(internal) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_send(spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_eq(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_neq(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_lt(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_le(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_gt(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_ge(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION spoken_lang_cmp(spoken_lang, spoken_lang) PARALLEL SAFE $E$;
	EXECUTE $E$ ALTER FUNCTION hash_spoken_lang(spoken_lang) PARALLEL SAFE $E$;
  END IF;
END;
$$;

