#!/bin/bash
eval "$(jq -r '@sh "TYPE=\(.type) REGION=\(.region)"')"

SELECTOR="select(.service | contains(\$type))"

if [ "null" != "$REGION" ]
  then
    SELECTOR="select((.service | contains(\$type)) and (.region | contains(\$region)))"
fi

curl https://ip-ranges.amazonaws.com/ip-ranges.json 2> /dev/null | \
  jq --arg type "$TYPE" --arg region "$REGION" \
    "{ ranges: [ .prefixes[] | $SELECTOR | .ip_prefix ] | join(\"|\") }"
