partners.json:
	./fetch.sh

partners.db: partners.json
	sqlite-utils insert partners.db partners partners.json --pk=_id

clean:
	rm partners.json partners.db
