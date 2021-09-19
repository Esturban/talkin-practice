# eda
require(dplyr)
#Exploratory Data Analysis
ds <- list.files(path = "data",
                 pattern = "*.csv",
                 full.names = T)
all_tables <- sapply(ds, readr::read_csv)
names(all_tables) <-
  gsub("olist_|_dataset|.csv|data\\/", "", names(all_tables))


# Rows: 99,441
# Columns: 5
# $ customer_id              <chr> "06b8999e2fba1a1fbc88172c00ba8bc7", "18955e83d337fd6b2def6b18a428ac77", "4e7b3e00288586ebd08712fdd0374a03", "b2b6027bc5c5109e52~
# $ customer_unique_id       <chr> "861eff4711a542e4b93843c6dd7febb0", "290c77bc529b7ac935b93aa66c333dc3", "060e732b5b29e8181a18229c7b0b2b5e", "259dac757896d24d77~
# $ customer_zip_code_prefix <chr> "14409", "09790", "01151", "08775", "13056", "89254", "04534", "35182", "81560", "30575", "39400", "20231", "18682", "05704", "~
# $ customer_city            <chr> "franca", "sao bernardo do campo", "sao paulo", "mogi das cruzes", "campinas", "jaragua do sul", "sao paulo", "timoteo", "curit~
# $ customer_state           <chr> "SP", "SP", "SP", "SP", "SP", "SC", "SP", "MG", "PR", "MG", "MG", "RJ", "SP", "SP", "RS", "SP", "RJ", "SP", "SP", "PA", "SC", "~
all_tables[['customers']] %>% glimpse()

#SP the most ordered to state,
all_tables[['customers']] %>%
  group_by(customer_state) %>%
  summarise(cust_unq = length(unique(customer_unique_id)),
            #Unique order identifier
            cust = length(unique(customer_id))) %>%
  mutate(pct = cust / sum(cust)) %>%
  arrange(desc(cust))

#Total number of orders by a single customer
all_tables[['customers']] %>%
  group_by(customer_unique_id) %>%
  summarise(#Unique order identifier
    orders = length(unique(customer_id))) %>%
  # mutate(pct = orders / sum(orders))%>%
  arrange(desc(orders))


# Rows: 99,441
# Columns: 8
# $ order_id                      <chr> "e481f51cbdc54678b7cc49136f2d6af7", "53cdb2fc8bc7dce0b6741e2150273451", "47770eb9100c2d0c44946d9cf07ec65d", "949d5b44dbf5d~
# $ customer_id                   <chr> "9ef432eb6251297304e76186b10a928d", "b0830fb4747a6c6d20dea0b8c802d7ef", "41ce2a54c0b03bf3443c3d931a367089", "f88197465ea79~
# $ order_status                  <chr> "delivered", "delivered", "delivered", "delivered", "delivered", "delivered", "invoiced", "delivered", "delivered", "deliv~
# $ order_purchase_timestamp      <dttm> 2017-10-02 10:56:33, 2018-07-24 20:41:37, 2018-08-08 08:38:49, 2017-11-18 19:28:06, 2018-02-13 21:18:39, 2017-07-09 21:57~
# $ order_approved_at             <dttm> 2017-10-02 11:07:15, 2018-07-26 03:24:27, 2018-08-08 08:55:23, 2017-11-18 19:45:59, 2018-02-13 22:20:29, 2017-07-09 22:10~
# $ order_delivered_carrier_date  <dttm> 2017-10-04 19:55:00, 2018-07-26 14:31:00, 2018-08-08 13:50:00, 2017-11-22 13:39:59, 2018-02-14 19:46:34, 2017-07-11 14:58~
# $ order_delivered_customer_date <dttm> 2017-10-10 21:25:13, 2018-08-07 15:27:45, 2018-08-17 18:06:29, 2017-12-02 00:28:42, 2018-02-16 18:17:02, 2017-07-26 10:57~
# $ order_estimated_delivery_date <dttm> 2017-10-18, 2018-08-13, 2018-09-04, 2017-12-15, 2018-02-26, 2017-08-01, 2017-05-09, 2017-06-07, 2017-03-06, 2017-08-23, 2~
all_tables[['orders']] %>% glimpse()

all_tables[['orders']] %>% inner_join(all_tables[['customers']], by = 'customer_id')

#2 Years / 25 months of order history from 2016-09 to 2018-10
#~4% of orders have not yet been delivered

summary(all_tables[['orders']])

# Rows: 112,650
# Columns: 7
# $ order_id            <chr> "00010242fe8c5a6d1ba2dd792cb16214", "00018f77f2f0320c557190d7a144bdd3", "000229ec398224ef6ca0657da4fc703e", "00024acbcdf0a6daa1e931b~
# $ order_item_id       <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 2, ~
# $ product_id          <chr> "4244733e06e7ecb4970a6e2683c13e61", "e5f2d52b802189ee658865ca93d83a8f", "c777355d18b72b67abbeef9df44fd0fd", "7634da152a4610f1595efa3~
# $ seller_id           <chr> "48436dade18ac8b2bce089ec2a041202", "dd7ddc04e1b6c2c614352b383efe2d36", "5b51032eddd242adc84c38acab88f23d", "9d7a1d34a50524090064252~
# $ shipping_limit_date <dttm> 2017-09-19 09:45:35, 2017-05-03 11:05:13, 2018-01-18 14:48:30, 2018-08-15 10:10:18, 2017-02-13 13:57:51, 2017-05-23 03:55:27, 2017-~
# $ price               <dbl> 58.90, 239.90, 199.00, 12.99, 199.90, 21.90, 19.90, 810.00, 145.95, 53.99, 59.99, 45.00, 74.00, 49.90, 49.90, 99.90, 639.00, 144.00,~
# $ freight_value       <dbl> 13.29, 19.93, 17.87, 12.79, 18.14, 12.69, 11.85, 70.75, 11.65, 11.40, 8.88, 12.98, 23.32, 13.37, 13.37, 27.65, 11.34, 8.77, 13.71, 1~
all_tables[['order_items']] %>% glimpse()


#See the value spent by individual users
#
all_tables[['order_items']] %>% inner_join(all_tables[['orders']], by = 'order_id') %>%
  inner_join(all_tables[['customers']], by = 'customer_id') %>%
  group_by(customer_unique_id) %>%
  summarise(#Unique order identifier
    ltv = sum(price + freight_value),
    orders = length(unique(order_id))) %>%
  # mutate(pct = orders / sum(orders))%>%
  # arrange(desc(orders))
  arrange(desc(ltv))



all_tables[['order_payments']] %>% group_by(payment_installments, payment_sequential) %>%
  summarise(n = n(),
            orders = length(order_id)) %>%
  print(n = 70)


#A lot of orders include comments, but exclude the titles
#Could not infer from the title for NLP
#Review score shows ~ almost 60% of orders report complete satisfaction
#Almost 80% of orders were mostly satisfied
all_tables[['order_reviews']] %>%
  group_by(review_score) %>%
  summarise(
    total = n(),
    rev_title_missing = paste0(round(sum(ifelse(
      is.na(review_comment_title), 1, 0
    )) / n() * 100, 2), "%"),
    rev_msg_missing = paste0(round(sum(ifelse(
      is.na(review_comment_message), 1, 0
    )) / n() * 100, 2), "%"),
  ) %>%
  mutate(pct = paste0(round(total / sum(total) * 100, 2), "%"))

#3095 sellers based out of regions
all_tables[['sellers']] %>% glimpse(.)
#Results for the top 10% of sellers
# seller_id             orders            skus            sales
# Length:309         Min.   :   4.0   Min.   :  1.00   Min.   :  9576
# Class :character   1st Qu.:  56.0   1st Qu.: 16.00   1st Qu.: 12630
# Mode  :character   Median : 110.0   Median : 30.00   Median : 16321
#                    Mean   : 196.4   Mean   : 50.49   Mean   : 29688
#                    3rd Qu.: 208.0   3rd Qu.: 64.00   3rd Qu.: 31942
#                    Max.   :1854.0   Max.   :399.00   Max.   :229473

all_tables[['sellers']] %>%
  inner_join(all_tables[['order_items']], by = 'seller_id') %>%
  group_by(seller_id) %>%
  summarise(
    orders = length(unique(order_id)),
    skus = length(unique(product_id)),
    sales = sum(price),
  ) %>%
  top_frac(wt = sales, 0.1) %>%
  arrange(desc(sales)) -> seller_perf

#Explore a naive cluster
seller_cluster <-
  stats::kmeans(seller_perf$sales, centers = 3, nstart = 10)
require(magrittr)
seller_perf %<>% merge(., seller_cluster$cluster)

require(plotly)
plot_ly(alpha = 0.6) %>%
  add_histogram(x = ~ seller_perf$sales[seller_perf$y == 1], type = 'histogram') %>%
  add_histogram(x = ~ seller_perf$sales[seller_perf$y == 2], type = 'histogram') %>%
  add_histogram(x = ~ seller_perf$sales[seller_perf$y == 3], type = 'histogram') %>%
  layout(barmode = "stack")


#Products

# Rows: 32,951
# Columns: 9
# $ product_id                 <chr> "1e9e8ef04dbcff4541ed26657ea517e5", "3aa071139cb16b67ca9e5dea641aaa2f", "96bd76ec8810374ed1b65e291975717f", "cef67bcfe19066a9~
# $ product_category_name      <chr> "perfumaria", "artes", "esporte_lazer", "bebes", "utilidades_domesticas", "instrumentos_musicais", "cool_stuff", "moveis_deco~
# $ product_name_lenght        <dbl> 40, 44, 46, 27, 37, 60, 56, 56, 57, 36, 54, 49, 43, 51, 59, 22, 39, 59, 56, 52, 27, 27, 58, 55, 56, 52, 52, 35, 59, 50, 45, 4~
# $ product_description_lenght <dbl> 287, 276, 250, 261, 402, 745, 1272, 184, 163, 1156, 630, 728, 1827, 2083, 1602, 3021, 346, 636, 296, 206, 158, 329, 1987, 162~
# $ product_photos_qty         <dbl> 1, 1, 1, 1, 4, 1, 4, 2, 1, 1, 1, 4, 3, 2, 4, 1, 2, 1, 2, 1, 4, 2, 3, 1, 1, 1, 5, 2, 2, 2, 1, 9, 1, 1, 4, 9, 2, 1, 1, 1, 2, 2,~
# $ product_weight_g           <dbl> 225, 1000, 154, 371, 625, 200, 18350, 900, 400, 600, 1100, 7150, 250, 600, 200, 800, 400, 900, 1700, 500, 2550, 800, 75, 500,~
# $ product_length_cm          <dbl> 16, 30, 18, 26, 20, 38, 70, 40, 27, 17, 16, 50, 17, 68, 17, 16, 27, 40, 100, 16, 29, 36, 21, 20, 40, 50, 35, 42, 23, 62, 16, ~
# $ product_height_cm          <dbl> 10, 18, 9, 4, 17, 5, 24, 8, 13, 10, 10, 19, 7, 11, 7, 2, 5, 15, 7, 10, 24, 8, 7, 13, 10, 5, 25, 2, 13, 23, 10, 8, 10, 51, 9, ~
# $ product_width_cm           <dbl> 14, 20, 15, 26, 13, 11, 44, 40, 17, 12, 16, 45, 17, 13, 17, 11, 20, 20, 15, 16, 45, 16, 13, 13, 30, 50, 50, 30, 13, 23, 16, 3~
all_tables[['products']] %>% glimpse()

all_tables[['order_items']] %>%
  inner_join(all_tables[['products']], by = 'product_id') %>%
  group_by(product_id) %>%
  summarise(
    orders = length(unique(order_id)),
    prices = n_distinct(price),
    sales = sum(price),
  ) %>%
  top_frac(wt = sales, 0.1) %>%
  arrange(desc(sales))

#Sale of Bottom 10% of items are ~25% of sales of top seller
#Sale of Bottom 20% of items are ~90% of sales of top seller
all_tables[['order_items']] %>%
  inner_join(all_tables[['products']], by = 'product_id') %>%
  group_by(product_id, product_category_name) %>%
  summarise(
    orders = length(unique(order_id)),
    prices = n_distinct(price),
    sales = sum(price),
    .groups = 'drop'
  ) %>%
  top_frac(wt = sales, -0.20) %>%
  group_by(product_category_name) %>%
  summarise(sales = sum(sales)) %>%
  mutate(tot_sales = sum(sales)) %>%
  arrange(desc(sales))


all_tables[['order_items']] %>%
  inner_join(all_tables[['products']], by = 'product_id') %>%
  group_by(product_id, product_category_name) %>%
  summarise(
    orders = length(unique(order_id)),
    prices = n_distinct(price),
    sales = sum(price),
    .groups = 'drop'
  ) %>%
  top_frac(wt = sales, 0.20) %>%
  group_by(product_category_name) %>%
  summarise(sales = sum(sales)) %>%
  mutate(tot_sales = sum(sales)) %>%
  arrange(desc(sales))

