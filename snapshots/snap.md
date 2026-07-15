#1
snapshots:
  - name: sales1_snapshot
    relation: source('youtube', 'sales')
    config:
      # schema: youtube_snapshots
      database: youtube
      unique_key: sale_id #column_name_or_expression
      strategy: timestamp
      updated_at: sale_timestamp
      dbt_valid_to_current: "'9999-12-31'"

#2 
snapshots:
  - name: sales2_snapshot
    relation: source('youtube', 'sales')
    config:
      # schema: youtube_snapshots
      database: youtube
      unique_key: sale_id
      strategy: check
      check_cols:
        - sale_amount
        - sale_status
        - amount 
        - customer_id 
        - product_id 
      dbt_valid_to_current: "'9999-12-31'" 

#3

snapshots:
  - name: sales3_snapshot
    relation: source('youtube', 'sales')
    config:
      # schema: youtube_snapshots
      database: youtube
      unique_key: sale_id
      strategy: timestamp
      updated_at: sale_timestamp
      dbt_valid_to_current: "'9999-12-31'" 
      hard_deletes: new_record # options are: 'ignore', 'invalidate', or 'new_record'

#4

snapshots:
  - name: sales4_snapshot
    relation: source('youtube', 'sales')
    config:
      # schema: youtube_snapshots
      database: youtube
      unique_key: sale_id
      strategy: timestamp
      updated_at: sale_timestamp
      dbt_valid_to_current: "'9999-12-31'" 
      hard_deletes: invalidate # options are: 'ignore', 'invalidate', or 'new_record'

#5
snapshots:
  - name: sales5_snapshot
    relation: source('youtube', 'sales')
    config:
      # schema: youtube_snapshots
      database: youtube
      unique_key: sale_id
      strategy: timestamp
      updated_at: sale_timestamp
      dbt_valid_to_current: "'9999-12-31'" 
      hard_deletes: new_record # options are: 'ignore', 'invalidate', or 'new_record'
      snapshot_meta_column_names:
        dbt_valid_from: valid_from_date
        dbt_valid_to: valid_to_date
        dbt_scd_id: scd_id
        dbt_updated_at: updated_date
        dbt_is_deleted: is_deleted

        #6

        {% snapshot sales_snapshotSQL %}

{{config(
        strategy='timestamp',
        unique_key='sale_id',
        updated_at='sale_timestamp',
        hard_deletes= 'new_record',
        )
}}

SELECT 
    *
FROM 
    {{ source('youtube', 'sales') }}

{% endsnapshot %}      
