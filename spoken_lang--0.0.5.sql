-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION spoken_lang" to load this file. \quit

CREATE TYPE spoken_lang;

CREATE FUNCTION supported_spoken_langs()
    RETURNS SETOF spoken_lang
    AS '$libdir/spoken_lang.so'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION spoken_lang_in(cstring)
    RETURNS spoken_lang
    AS '$libdir/spoken_lang.so'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION spoken_lang_out(spoken_lang)
    RETURNS cstring
    AS '$libdir/spoken_lang.so'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION spoken_lang_recv(internal)
    RETURNS spoken_lang
    AS '$libdir/spoken_lang.so'
    LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION spoken_lang_send(spoken_lang)
    RETURNS bytea
    AS '$libdir/spoken_lang.so'
    LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE spoken_lang (
    internallength = 1,
    input = spoken_lang_in,
    output = spoken_lang_out,
    send = spoken_lang_send,
    receive = spoken_lang_recv,
    alignment = char,
    PASSEDBYVALUE
);

COMMENT ON TYPE spoken_lang
  IS '1-byte adjust-specific spoken_lang Code';

CREATE FUNCTION spoken_lang_lt(spoken_lang, spoken_lang)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'charlt';

COMMENT ON FUNCTION spoken_lang_lt(spoken_lang, spoken_lang) IS 'implementation of < operator';

CREATE FUNCTION spoken_lang_le(spoken_lang, spoken_lang)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'charle';

COMMENT ON FUNCTION spoken_lang_le(spoken_lang, spoken_lang) IS 'implementation of <= operator';

CREATE FUNCTION spoken_lang_eq(spoken_lang, spoken_lang)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'chareq';

COMMENT ON FUNCTION spoken_lang_eq(spoken_lang, spoken_lang) IS 'implementation of = operator';

CREATE FUNCTION spoken_lang_neq(spoken_lang, spoken_lang)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'charne';

COMMENT ON FUNCTION spoken_lang_neq(spoken_lang, spoken_lang) IS 'implementation of <> operator';

CREATE FUNCTION spoken_lang_ge(spoken_lang, spoken_lang)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'charge';

COMMENT ON FUNCTION spoken_lang_ge(spoken_lang, spoken_lang) IS 'implementation of >= operator';

CREATE FUNCTION spoken_lang_gt(spoken_lang, spoken_lang)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'chargt';

COMMENT ON FUNCTION spoken_lang_gt(spoken_lang, spoken_lang) IS 'implementation of > operator';

CREATE FUNCTION hash_spoken_lang(spoken_lang)
RETURNS integer LANGUAGE internal IMMUTABLE AS 'hashchar';

COMMENT ON FUNCTION hash_spoken_lang(spoken_lang) IS 'hash';

CREATE OPERATOR < (
    leftarg = spoken_lang,
    rightarg = spoken_lang,
    procedure = spoken_lang_lt,
    commutator = >,
    negator   = >=,
    restrict = scalarltsel,
    join = scalarltjoinsel
);

COMMENT ON OPERATOR <(spoken_lang, spoken_lang) IS 'less than';

CREATE OPERATOR <= (
    leftarg = spoken_lang,
    rightarg = spoken_lang,
    procedure = spoken_lang_le,
    commutator = >=,
    negator   = >,
    restrict = scalarltsel,
    join = scalarltjoinsel
);

COMMENT ON OPERATOR <=(spoken_lang, spoken_lang) IS 'less than or equal';

CREATE OPERATOR = (
    leftarg = spoken_lang,
    rightarg = spoken_lang,
    procedure = spoken_lang_eq,
    commutator = =,
    negator   = <>,
    restrict = eqsel,
    join = eqjoinsel,
    HASHES, MERGES
);

COMMENT ON OPERATOR =(spoken_lang, spoken_lang) IS 'equal';

CREATE OPERATOR >= (
    leftarg = spoken_lang,
    rightarg = spoken_lang,
    procedure = spoken_lang_ge,
    commutator = <=,
    negator   = <,
    restrict = scalargtsel,
    join = scalargtjoinsel
);

COMMENT ON OPERATOR >=(spoken_lang, spoken_lang) IS 'greater than or equal';

CREATE OPERATOR > (
    leftarg = spoken_lang,
    rightarg = spoken_lang,
    procedure = spoken_lang_gt,
    commutator = <,
    negator   = <=,
    restrict = scalargtsel,
    join = scalargtjoinsel
);

COMMENT ON OPERATOR >(spoken_lang, spoken_lang) IS 'greater than';

CREATE OPERATOR <> (
    leftarg = spoken_lang,
    rightarg = spoken_lang,
    procedure = spoken_lang_neq,
    commutator = <>,
    negator = =,
    restrict = neqsel,
    join = neqjoinsel
);

COMMENT ON OPERATOR <>(spoken_lang, spoken_lang) IS 'not equal';

CREATE FUNCTION spoken_lang_cmp(spoken_lang, spoken_lang)
RETURNS integer LANGUAGE internal IMMUTABLE AS 'btcharcmp';

CREATE OPERATOR CLASS spoken_lang_ops
    DEFAULT FOR TYPE spoken_lang USING btree AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       spoken_lang_cmp(spoken_lang, spoken_lang);

CREATE OPERATOR CLASS spoken_lang_ops
    DEFAULT FOR TYPE spoken_lang USING hash AS
        OPERATOR        1       = ,
        FUNCTION        1       hash_spoken_lang(spoken_lang);


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

