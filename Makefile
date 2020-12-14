partners.db: partners.json
	@echo BEGIN DUPLICATES
	@jq ".[]._id" < partners.json | sort | uniq -cd
	@echo END DUPLICATES
	sqlite-utils insert --alter partners.db partners partners.json --pk=_id --ignore
	sqlite-utils transform partners.db partners -o literal_name
	./create-summary-view.sh

partners.json:
	./fetch.sh

.PHONY: publish
publish: partners.db
ifndef NOW_TOKEN
	datasette publish vercel partners.db --project=aws-partners-singapore --install datasette-json-html --metadata metadata.yaml --setting default_page_size 10 --setting max_returned_rows 100
else
	datasette publish vercel partners.db --project=aws-partners-singapore --install datasette-json-html --metadata metadata.yaml --token ${NOW_TOKEN} --setting default_page_size 10 --setting max_returned_rows 100
endif

.PHONY: run
run:
	datasette partners.db --metadata metadata.yaml

.PHONY: clean
clean:
	rm -f partners.json partners.db
