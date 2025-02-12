select 
 id as customer_id,
 orderid,
amount
from {{ source('stripe', 'payment') }}