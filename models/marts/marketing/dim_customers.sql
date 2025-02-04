
with customers as (

select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

    select * from {{ ref('stg_stripe__payments') }}
),

customer_orders as (

	select 
		customer_id,
		min(order_date) as first_order_date,
		max(order_date) as most_recent_order,
		count(order_id) as number_of_orders
	from orders
	
	group by customer_id
),

customer_payment as(
    select 
        customer_id,
        sum(amount) as lifetime_value
    from payments
    group by customer_id

),

final as (

	select
		customers.customer_id,
		customers.first_name,
		customers.last_name,
		customer_orders.first_order_date,
		customer_orders.most_recent_order,
		coalesce(customer_orders.number_of_orders,0) as number_of_orders,
		customer_payment.lifetime_value

	from customers
	
	left join customer_orders 
    left join customer_payment 
    where customers.customer_id=customer_orders.customer_id and 
    customers.customer_id=customer_payment.customer_id
	
)

select * from final