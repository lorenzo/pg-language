/*
 * Code is heavily inspired from pg-currency
 *
 * -- ms
 */

#include "spoken_lang.h"
#include "spoken_lang_forward.h"
#include "spoken_lang_reverse.h"

#include "access/hash.h"
#include "funcapi.h"
#include "libpq/pqformat.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(spoken_lang_in);
PG_FUNCTION_INFO_V1(spoken_lang_out);
PG_FUNCTION_INFO_V1(spoken_lang_recv);
PG_FUNCTION_INFO_V1(spoken_lang_send);
PG_FUNCTION_INFO_V1(supported_spoken_langs);

Datum spoken_lang_in(PG_FUNCTION_ARGS)
{
    char *str = PG_GETARG_CSTRING(0);

    if (strlen(str) != 2)
        elog(ERROR, "invalid spoken_lang input string %s", str);

    PG_RETURN_spoken_lang(lang_from_str(str));
}

Datum spoken_lang_out(PG_FUNCTION_ARGS)
{
    const spoken_lang_code curr = PG_GETARG_CHAR(0);

    PG_RETURN_CSTRING(spoken_lang_to_str(curr));
}

Datum spoken_lang_recv(PG_FUNCTION_ARGS)
{
    StringInfo    buf    = (StringInfo) PG_GETARG_POINTER(0);
    spoken_lang_code result = pq_getmsgbyte(buf);
    PG_RETURN_spoken_lang(result);
}

Datum spoken_lang_send(PG_FUNCTION_ARGS)
{
    const spoken_lang_code a = PG_GETARG_spoken_lang(0);
    StringInfoData      buf;

    pq_begintypsend(&buf);
    pq_sendbyte(&buf, a);
    PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}

Datum supported_spoken_langs(PG_FUNCTION_ARGS)
{
    FuncCallContext *funcctx;

    /* stuff done only on the first call of the function */
    if (SRF_IS_FIRSTCALL())
    {
        /* create a function context for cross-call persistence */
        funcctx = SRF_FIRSTCALL_INIT();
    }

    /* stuff done on every call of the function */
    funcctx = SRF_PERCALL_SETUP();

    if (funcctx->call_cntr + 1 < LANG_MAX)
    {
        Datum lang = spoken_langGetDatum(funcctx->call_cntr + 1);

        /* do when there is more left to send */
        SRF_RETURN_NEXT(funcctx, lang);
    }
    else
    {
        /* do when there is no more left */
        SRF_RETURN_DONE(funcctx);
    }
}
