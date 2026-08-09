{{
    config(
        
        materialized='view'
    )
    
    }}

    select * from dbt_sql.raw.orders limit 10