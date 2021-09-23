# 02_features

#Group by necessary order information to determine how possible it is to
#sell in a specific region a certain number of orders and items
all_tables[['orders_zipcode_daily']] <- all_tables[['orders']] %>%
  inner_join(all_tables[['order_items']], by = "order_id") %>%
  inner_join(all_tables[['customers']], by = "customer_id") %>%
  inner_join(all_tables[['sellers']], by = "seller_id") %>%
  # glimpse()
  group_by(
    date = as.Date(order_purchase_timestamp),
    customer_zip_code_prefix,
    seller_zip_code_prefix
  ) %>%
  summarise(
    transactions = length(unique(order_id)),
    items = length(unique(paste0(
      order_id, order_item_id
    ))),
    .groups = 'drop'
  )%>%
timetk::tk_augment_timeseries_signature(.date_var = "date") %>%
select(-c(hour:hour12))


all_tables[['orders_daily']] <- all_tables[['orders']]%>%
  mutate(date = as.Date(order_purchase_timestamp))%>%
  group_by(date)
