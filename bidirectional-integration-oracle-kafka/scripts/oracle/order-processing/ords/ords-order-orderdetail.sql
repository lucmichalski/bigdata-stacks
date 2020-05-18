-- Generated by Oracle SQL Developer REST Data Services 18.3.0.277.2354
-- Exported REST Definitions from ORDS Schema Version 19.1.1.r1081514
-- Schema: ORDER_PROCESSING   Date: Sun Sep 29 18:35:41 PDT 2019
--
BEGIN
  ORDS.ENABLE_SCHEMA(
      p_enabled             => TRUE,
      p_schema              => 'ORDER_PROCESSING',
      p_url_mapping_type    => 'BASE_PATH',
      p_url_mapping_pattern => 'order_processing',
      p_auto_rest_auth      => FALSE);    

  ORDS.DEFINE_MODULE(
      p_module_name    => 'order_processing',
      p_base_path      => '/orders/',
      p_items_per_page =>  25,
      p_status         => 'PUBLISHED',
      p_comments       => NULL);      
  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'order_processing',
      p_pattern        => ':id',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);
  ORDS.DEFINE_HANDLER(
      p_module_name    => 'order_processing',
      p_pattern        => ':id',
      p_method         => 'GET',
      p_source_type    => 'resource/lob',
      p_items_per_page =>  25,
      p_mimes_allowed  => '',
      p_comments       => NULL,
      p_source         => 
'SELECT ''application/json'', json_object(''orderId'' VALUE po.id,
          ''orderDate'' VALUE po.order_date,
          ''orderMode'' VALUE po.order_mode,
          ''orderStatus'' VALUE DECODE (po.order_status,2,''PROCESSING''),
          ''totalPrice'' VALUE po.order_total,
          ''customer'' VALUE
              json_object(''firstName'' VALUE cu.first_name,
                          ''lastName'' VALUE cu.last_name,
                          ''emailAddress'' VALUE cu.email
                          ),
          ''items'' VALUE (SELECT json_arrayagg(
              json_object(''itemNumber'' VALUE li.id,
                     ''product'' VALUE
                       json_object(''id'' VALUE li.product_id,
                                   ''name'' VALUE li.product_name,
                                   ''unitPrice'' VALUE li.unit_price),
                      ''quantity'' VALUE li.quantity))
                      FROM order_item_t li WHERE po.id = li.order_id))
               FROM order_t po LEFT JOIN customer_t cu ON (po.customer_id = cu.id)
               where po.id = :id'
      );
  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'order_processing',
      p_pattern        => 'changes/:offset',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);
  ORDS.DEFINE_HANDLER(
      p_module_name    => 'order_processing',
      p_pattern        => 'changes/:offset',
      p_method         => 'GET',
      p_source_type    => 'resource/lob',
      p_items_per_page =>  1,
      p_mimes_allowed  => '',
      p_comments       => NULL,
      p_source         => 
'SELECT ''application/json'', json_object(''orderId'' VALUE po.id,
          ''orderDate'' VALUE po.order_date,
          ''orderMode'' VALUE po.order_mode,
          ''orderStatus'' VALUE DECODE (po.order_status,2,''PROCESSING''),
          ''totalPrice'' VALUE po.order_total,
          ''customer'' VALUE
              json_object(''firstName'' VALUE cu.first_name,
                          ''lastName'' VALUE cu.last_name,
                          ''emailAddress'' VALUE cu.email
                          ),
          ''items'' VALUE (SELECT json_arrayagg(
              json_object(''itemNumber'' VALUE li.id,
                     ''product'' VALUE
                       json_object(''id'' VALUE li.product_id,
                                   ''name'' VALUE li.product_name,
                                   ''unitPrice'' VALUE li.unit_price),
                      ''quantity'' VALUE li.quantity))
                      FROM order_item_t li WHERE po.id = li.order_id),
         ''Offset'' VALUE TO_CHAR(po.modified_at, ''YYYYMMDDHH24MISS''))
FROM order_t po LEFT JOIN customer_t cu ON (po.customer_id = cu.id)
WHERE po.modified_at > TO_DATE(:offset, ''YYYYMMDDHH24MISS'')'
      );


  COMMIT; 
END;
/