

with raw_order as (
    select 
        o_orderkey as order_id,
        o_orderstatus as status,
        o_custkey as customer_id -- Fixed zero "0" to letter "o"

    from dbt_sql.raw.orders
)

select * from raw_order -- Match the exact CTE name defined above
