#!/bin/bash

size=100
from=0
tmp=$(mktemp)

while curl -f -s "https://api.finder.partners.aws.a2z.com/search?locale=en&size=$size&from=$from" |
	jq '.message.results |map(del(._source) + ._source)' > $tmp
do
	test -s $tmp || break
	echo -n Fetched $(jq 'length' $tmp) records
	test $(jq 'length' $tmp) -eq 0 && break
	cat $tmp >> partners.json
	from=$(($from + $size))
	echo .. fetching from: $from
done

jq -s 'add' < partners.json > $tmp
jq 'length' $tmp
mv $tmp partners.json
