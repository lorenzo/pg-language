#!/bin/bash

if [ $3 == src/lang_rev.awk ]; then
cat > $1 <<-EOF
/*
 * code automatically generated with make and build_lang.sh
 */

#ifndef LANG_REV_H
#define LANG_REV_H
#include "spoken_lang.h"
static inline spoken_lang_code
lang_from_str(const char *str)
{
    switch (str[0] << 8 | str[1])
    {
EOF
    sort $2 | awk -f $3 >> $1
    cat >> $1 <<-EOF
    default: elog(ERROR, "unknown spoken_lang type: %s", str);
    }
};
#endif
EOF

elif [ $3 == src/lang_fwd.awk ]; then
    cat > $1 <<-EOF
/*
 * code automatically generated with make and build_lang.sh
 */

#ifndef LANG_FWD_H
#define LANG_FWD_H

#include "spoken_lang.h"

static inline char *
create_string(const char *chars)
{
    char *str = (char *) palloc(3 * sizeof(char));
    memcpy(str, chars, 2 * sizeof(char));
    str[2] = '\0';
    return str;
}

static inline char *
spoken_lang_to_str(spoken_lang_code c)
{
    switch (c)
    {
EOF
    sort -k 3 -n $2 | awk -f $3 >> $1
    cat >> $1 <<-EOF
    default: elog(ERROR, "internal spoken_lang representation unknown: %u", c);
    }
}
#endif
EOF
else
    echo "unknown awk command"
    exit 1
fi
