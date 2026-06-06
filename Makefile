SERVICE = aws-datasette

partners.db: partners.json
	@echo BEGIN DUPLICATES
	@jq ".[]._id" < partners.json | sort | uniq -cd
	@echo END DUPLICATES
	uv run sqlite-utils insert --alter partners.db partners partners.json --pk=_id --ignore
	./create-summary-view.sh

partners.json:
	./fetch.sh

.PHONY: publish
publish: partners.db
	uv run datasette publish fly partners.db --app="aws-partners" --metadata metadata.yaml \
	  --install datasette-block-robots --install datasette-json-html --install datasette-copyable

.PHONY: run
run:
	test -f partners.db || { zstd -d --keep partners/*.ndjson.zst 2>/dev/null; uv run sqlite-diffable load partners.db partners/; }
	uv run datasette partners.db --metadata metadata.yaml

.PHONY: agent
agent:
	test -f partners.db || { zstd -d --keep partners/*.ndjson.zst 2>/dev/null; uv run sqlite-diffable load partners.db partners/; }
	curl -sf "https://kaihendry.github.io/aws-partners-datasette/premier.csv" | \
	  uv run sqlite-utils insert partners.db premier - --csv --alter --replace 2>/dev/null || true
	uvx --prerelease=allow --with datasette-agent --with datasette-agent-charts --with llm-gemini \
	  datasette partners.db --metadata metadata.yaml \
	  -s plugins.datasette-llm.default_model gemini/gemini-3.5-flash \
	  --internal internal.db --root

.PHONY: clean
clean:
	rm -f partners.json partners.db
