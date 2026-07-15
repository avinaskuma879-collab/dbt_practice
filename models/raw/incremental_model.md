models:
  - name: my_incremental_model
    config:
      materialized: incremental
      unique_key: id
      # this will affect how the data is stored on disk, and indexed to limit scans
      cluster_by: ['session_start']  
      incremental_strategy: merge
      # this limits the scan of the existing table to the last 7 days of data
      incremental_predicates: ["DBT_INTERNAL_DEST.session_start > dateadd(day, -7, current_date)"]
      # `incremental_predicates` accepts a list of SQL statements. 
      # `DBT_INTERNAL_DEST` and `DBT_INTERNAL_SOURCE` are the standard aliases for the target table and temporary table, 
      respectively, during an incremental run using the merge strategy.

      incremental_predicates is an advanced use of incremental models, where data volume is
       large enough to justify additional investments in performance. 
      This config accepts a list of any valid SQL expression(s). dbt does not check the syntax of the SQL statements.


{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    cluster_by = ['session_start'],  
    incremental_strategy = 'merge',
    on_schema_change='fail'
    incremental_predicates = [
      "DBT_INTERNAL_DEST.session_start > dateadd(day, -7, current_date)"
    ]
  )
}}

merge into <existing_table> DBT_INTERNAL_DEST
    from <temp_table_with_new_records> DBT_INTERNAL_SOURCE
    on
        -- unique key
        DBT_INTERNAL_DEST.id = DBT_INTERNAL_SOURCE.id
        and
        -- custom predicate: limits data scan in the "old" data / existing table
        DBT_INTERNAL_DEST.session_start > dateadd(day, -7, current_date)
    when matched then update ...
    when not matched then insert ...


The unique_key should be supplied in your model definition as a string
 representing a single column or a list of single-quoted column names 
 that can be used together, for example, ['col1', 'col2', …]). Columns used in 
 this way should not contain any nulls, or the incremental model may fail to match rows and 
 generate duplicate rows. Either ensure that each column has no nulls (for example with coalesce(COLUMN_NAME, 'VALUE_IF_NULL')) 
or define a single-column surrogate key (for example with dbt_utils.generate_surrogate_key).