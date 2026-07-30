-- created_at: 2026-07-30T17:26:02.340360500+00:00
-- finished_at: 2026-07-30T17:26:02.912648600+00:00
-- elapsed: 572ms
-- outcome: success
-- dialect: databricks
-- node_id: not available
-- query_id: 01f18c3b-bdb2-1f50-a406-ef6ddcf1c164
-- desc: list_relations_in_parallel (UC)

SELECT
    table_name,
    if(table_type IN ('EXTERNAL', 'MANAGED', 'MANAGED_SHALLOW_CLONE', 'EXTERNAL_SHALLOW_CLONE'), 'table', lower(table_type)) AS table_type,
    lower(data_source_format) AS file_format,
    table_schema,
    table_owner,
    table_catalog,
    if(
    table_type IN (
        'EXTERNAL',
        'MANAGED',
        'MANAGED_SHALLOW_CLONE',
        'EXTERNAL_SHALLOW_CLONE'
    ),
    lower(table_type),
    NULL
    ) AS databricks_table_type
FROM `system`.`information_schema`.`tables`
WHERE table_catalog = 'shopflow_analytics_cat'
    AND table_schema = 'gold';
-- created_at: 2026-07-30T17:26:03.671036900+00:00
-- finished_at: 2026-07-30T17:26:04.222317300+00:00
-- elapsed: 551ms
-- outcome: success
-- dialect: databricks
-- node_id: not available
-- query_id: 01f18c3b-be7d-1251-87f2-0d12eff223af
-- desc: execute adapter call
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "shopflow_analytics", "target_name": "dev"} */
SHOW SCHEMAS IN `shopflow_analytics_cat`;
-- created_at: 2026-07-30T17:26:04.866307200+00:00
-- finished_at: 2026-07-30T17:26:05.606309200+00:00
-- elapsed: 740ms
-- outcome: error
-- error vendor code: -2147483648
-- error message: Internal: failed to execute query: databricks: execution error: failed to execute query: unexpected operation state ERROR_STATE: [TABLE_OR_VIEW_NOT_FOUND] The table or view `shopflow_analytics_cat`.`silver`.`int_orders_enriched` cannot be found. Verify the spelling and correctness of the schema and catalog.
Search path: [`system`.`session`, `system`.`builtin`, `system`.`ai`, `shopflow_analytics_cat`.`silver`].
If you did not qualify the name with a schema, verify the current_schema() output, or qualify the name with the correct schema and catalog.
To tolerate the error on drop use DROP VIEW IF EXISTS or DROP TABLE IF EXISTS. SQLSTATE: 42P01; line 21 pos 18
-- dialect: databricks
-- node_id: model.shopflow_analytics.fct_orders
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.shopflow_analytics.fct_orders", "profile_name": "shopflow_analytics", "target_name": "dev"} */
create or replace table `shopflow_analytics_cat`.`gold`.`fct_orders`
      
      
    
      using delta
    
  
      
      
      
      
      
      
      
      as
      -- Fact: one row per order (incremental)


with orders_enriched as (
    select * from `shopflow_analytics_cat`.`silver`.`int_orders_enriched`
    
),

final as (
    select
        order_id,
        customer_id,
        order_date,
        status,
        order_total_amount as revenue,
        line_count as number_of_lines,
        total_quantity as total_units,
        customer_country,
        md5(cast(concat(coalesce(cast(order_id as string), '_dbt_utils_surrogate_key_null_')) as string)) as order_key
    from orders_enriched
)

select * from final;
