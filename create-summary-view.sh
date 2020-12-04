sqlite-utils create-view --replace partners.db summary <<HERE 'select
json_object(
    "href", "https://partners.amazonaws.com/partners/" || _id,
    "label", literal_name
) as partner_info,
customer_type, 
current_program_status, 
website, 
customer_launches_count, 
services_count 
from partners 
order by customer_launches_count DESC'
HERE
