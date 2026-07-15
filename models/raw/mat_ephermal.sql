{{
    config(
        
        materialized='ephemeral'
    )
    
    }}

    select distinct o_orderkey from dbt_sql.raw.orders;