{{
    config(
        
        materialized='ephemeral',
        tags=['mat_inc']
    )
    
    }}

    select distinct o_orderkey from dbt_sql.raw.orders;