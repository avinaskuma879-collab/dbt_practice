with 

source as (

    select * from {{ source('SRC_DBT_RAW', 'customer_raw') }}

),

renamed as (

    select
        c_custkey,
        c_name,
        c_address,
        c_nationkey,
        c_phone,
        c_acctbal,
        c_mktsegment,
        c_comment

    from source limit 100

)

select * from renamed