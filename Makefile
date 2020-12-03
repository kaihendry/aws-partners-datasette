partners.db: partners.json
	sqlite-utils insert --alter partners.db partners partners.json --pk=_id
	sqlite-utils transform partners.db partners -o literal_name

partners.json:
	./fetch.sh

clean:
	rm partners.json partners.db
