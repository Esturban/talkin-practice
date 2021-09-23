#Convert the zip code prefix into a numeric value
all_tables[['customers']] %<>% mutate(customer_zip_code_prefix = as.numeric(customer_zip_code_prefix))
all_tables[['sellers']] %<>% mutate(seller_zip_code_prefix = as.numeric(seller_zip_code_prefix))
all_tables[['geolocation']]%<>% mutate(geolocation_zip_code_prefix = as.numeric(geolocation_zip_code_prefix))
# all_tables[['order_items']]
# all_tables[['order_payments']]
# all_tables[['order_reviews']]
# all_tables[['orders']]
# all_tables[['products']]
# all_tables[['sellers']]