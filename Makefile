SERVICE = aws-datasette

partners.db: partners.json
	@echo BEGIN DUPLICATES
	@jq ".[]._id" < partners.json | sort | uniq -cd
	@echo END DUPLICATES
	sqlite-utils insert --alter partners.db partners partners.json --pk=_id --ignore
	./create-summary-view.sh

partners.json:
	./fetch.sh

.PHONY: publish
publish: partners.db
	datasette publish fly partners.db --app="aws-partners" --metadata metadata.yaml \
	  --install datasette-block-robots --install datasette-json-html --install datasette-copyable

.PHONY: run
run:
	datasette partners.db --metadata metadata.yaml

.PHONY: clean
clean:
	rm -f partners.json partners.db

deps:
	python -m venv .venv
	source .venv/bin/activate
	pip install -r requirements.txt
