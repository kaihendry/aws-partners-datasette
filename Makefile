partners.db: partners.json
	sqlite-utils insert --alter partners.db partners partners.json --pk=_id
	sqlite-utils transform partners.db partners -o literal_name
	./create-summary-view.sh

partners.json:
	./fetch.sh

publish:
	datasette publish vercel partners.db --project=aws-partners-singapore --install datasette-json-html --metadata metadata.yaml

clean:
	rm partners.json partners.db
