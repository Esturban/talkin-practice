# order_items

#Rows: 112,650
# Columns: 7
# $ order_id            <chr> "00010242fe8c5a6d1ba2dd792cb16214", "00018f77f2f0320c557190d7a144bdd3", "000229ec398224ef6ca0657da4fc703e", "00024acbcdf0a6daa1e931b03811~
# $ order_item_id       <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 1,~
# $ product_id          <chr> "4244733e06e7ecb4970a6e2683c13e61", "e5f2d52b802189ee658865ca93d83a8f", "c777355d18b72b67abbeef9df44fd0fd", "7634da152a4610f1595efa32f147~
# $ seller_id           <chr> "48436dade18ac8b2bce089ec2a041202", "dd7ddc04e1b6c2c614352b383efe2d36", "5b51032eddd242adc84c38acab88f23d", "9d7a1d34a5052409006425275ba1~
# $ shipping_limit_date <dttm> 2017-09-19 09:45:35, 2017-05-03 11:05:13, 2018-01-18 14:48:30, 2018-08-15 10:10:18, 2017-02-13 13:57:51, 2017-05-23 03:55:27, 2017-12-14~
# $ price               <dbl> 58.90, 239.90, 199.00, 12.99, 199.90, 21.90, 19.90, 810.00, 145.95, 53.99, 59.99, 45.00, 74.00, 49.90, 49.90, 99.90, 639.00, 144.00, 99.0~
# $ freight_value       <dbl> 13.29, 19.93, 17.87, 12.79, 18.14, 12.69, 11.85, 70.75, 11.65, 11.40, 8.88, 12.98, 23.32, 13.37, 13.37, 27.65, 11.34, 8.77, 13.71, 16.11,~

all_tables[['order_items']]%>%glimpse()

all_tables[['orders']]%>%
inner_join(all_tables[['order_items']])%>%
inner_join(all_tables[['products']])%>%
inner_join(all_tables[['product_category_name_translation']])%>%
  #Determine the type of items that are being purchased
group_by(product_category_name_english)%>%
  tidyr::nest(data = order_id:product_width_cm)%>%
  ungroup(.)%>%
  #And develop a feature set to understand the product a little better as well as how things sell
  mutate(avg_freight = purrr::map_dbl(.x = data,~mean(.x$freight_value)),
         avg_price = purrr::map_dbl(.x = data,~mean(.x$price)),
         unq_products = purrr::map_dbl(.x = data,~length(unique(.x$product_id))),
         sales = purrr::map_dbl(.x = data,~ sum(.x$price)),
         aov = purrr::map_dbl(.x = data,~ sum(.x$price)/length(unique(.x$order_id))),
         pct_sales = sales/sum(sales),
         fr_pr = avg_freight/avg_price
  )%>%
  arrange(desc(pct_sales))%>%
  #Determine the proportion of sales made up by the top n categories
  mutate(prop = cumsum(pct_sales))%>%print(n=20)


#The majority of sales are in health, beauty, bed, bath, watches, gifts and computer accessories


