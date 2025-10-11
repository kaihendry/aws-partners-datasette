# Drop the old view if it exists and create a materialized table instead
sqlite3 partners.db "DROP VIEW IF EXISTS summary;"
sqlite3 partners.db "DROP TABLE IF EXISTS summary;"

# Create materialized table with pre-computed rankings
sqlite3 partners.db <<HERE
CREATE TABLE summary AS
SELECT
  DENSE_RANK() OVER (ORDER BY customer_launches_count DESC) as launch_rank,
  json_object(
    'href', 'https://partners.amazonaws.com/partners/' || _id,
    'label', literal_name
  ) as partner_info,
  json_object(
    'img_src', download_url,
    'width', 200
  ) as logo,
  customer_type,
  current_program_status,
  website,
  customer_launches_count,
  services_count,
  reference_count,
  aws_certifications_count,
  office_address
FROM partners
ORDER BY customer_launches_count DESC;
HERE

# Create index on the materialized table for fast access
sqlite3 partners.db "CREATE INDEX IF NOT EXISTS idx_summary_launch_rank ON summary(launch_rank);"
echo "Summary table created with $(sqlite3 partners.db 'SELECT COUNT(*) FROM summary;') rows"
