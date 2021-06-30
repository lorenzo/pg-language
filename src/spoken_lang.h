#ifndef LANGUGA_H
#define LANGUGA_H

#include "postgres.h"

#include "fmgr.h"

typedef uint8 spoken_lang_code;

static const spoken_lang_code LANG_MAX = 186;

#define PG_RETURN_UINT8(x) return UInt8GetDatum(x)
#define PG_GETARG_UINT8(x) DatumGetUInt8(PG_GETARG_DATUM(x))

#define PG_RETURN_spoken_lang(x) PG_RETURN_UINT8(x)
#define PG_GETARG_spoken_lang(c) PG_GETARG_UINT8(c)
#define spoken_langGetDatum(x) (CharGetDatum(x))

Datum spoken_lang_in(PG_FUNCTION_ARGS);
Datum spoken_lang_out(PG_FUNCTION_ARGS);
Datum spoken_lang_recv(PG_FUNCTION_ARGS);
Datum spoken_lang_send(PG_FUNCTION_ARGS);
Datum supported_spoken_langs(PG_FUNCTION_ARGS);

#endif
