partners.db: partners.json
	sqlite-utils insert --alter partners.db partners partners.json --pk=_id
	sqlite-utils transform partners.db partners -o literal_name
	sqlite-utils create-view partners.db summary 'select _id, literal_name, customer_type, current_program_status, website, customer_launches_count, services_count from partners order by customer_launches_count DESC'

partners.json:
	./fetch.sh

clean:
	rm partners.json partners.db
