{% snapshot orders_snapshot %}

{{
    config(
        strategy='timestamp',
        unique_key='o_orderkey',
        updated_at='etl_last_updated_date'
    )
}}

select * from {{ source('SRC_DBT_RAW', 'orders') }}

{% endsnapshot %}
