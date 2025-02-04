select 
orderid,
customer_id,
amount
from {{ ref('stg_stripe__payments') }}