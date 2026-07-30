-- back compat for old kwarg name
  
  
  
  
  
  
      
          
          
      
  

    merge
    into
        `shopflow_analytics_cat`.`gold`.`fct_orders` as DBT_INTERNAL_DEST
    using
        `fct_orders__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
              DBT_INTERNAL_SOURCE.`order_id` <=> DBT_INTERNAL_DEST.`order_id`
          
    when matched
        then update set
            `status` = DBT_INTERNAL_SOURCE.`status`, `revenue` = DBT_INTERNAL_SOURCE.`revenue`, `number_of_lines` = DBT_INTERNAL_SOURCE.`number_of_lines`, `total_units` = DBT_INTERNAL_SOURCE.`total_units`, `customer_country` = DBT_INTERNAL_SOURCE.`customer_country`
    when not matched
        then insert
            *
