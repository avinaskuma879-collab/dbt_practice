{{
    config(
        
        materialized='table'
    )
    
    }}

    select * from dbt_sql.raw.orders limit 10