uv run sqlite-utils create-view --replace partners.db summary <<HERE 'select
DENSE_RANK() OVER ( ORDER BY customer_launches_count DESC) launch_rank,
json_object(
    "href", "https://partners.amazonaws.com/partners/" || _id,
    "label", literal_name
) as partner_info,
json_object(
    "img_src",
    download_url,
    "width",
    200
) as logo,
customer_type,
current_program_status,
website,
customer_launches_count,
services_count,
reference_count,
aws_certifications_count,
office_address
from partners
order by customer_launches_count DESC'
HERE
