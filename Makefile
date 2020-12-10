partners.db: partners.json
	@echo BEGIN DUPLICATES
	@jq ".[]._id" < partners.json | sort | uniq -cd
	@echo END DUPLICATES
	sqlite-utils insert --alter partners.db partners partners.json --pk=_id --ignore
	sqlite-utils transform partners.db partners -o literal_name
	./create-summary-view.sh

partners.json:
	./fetch.sh

publish: partners.db
	datasette publish vercel partners.db --project=aws-partners-singapore --install datasette-json-html --metadata metadata.yaml --token ${NOW_TOKEN}

clean:
	rm -f partners.json partners.db
