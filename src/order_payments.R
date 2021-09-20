# order_payments

# Rows: 103,886
# Columns: 5
# $ order_id             <chr> "b81ef226f3fe1789b1e8b2acac839d17", "a9810da82917af2d9aefd1278f1dcfa0", "25e8ea4e93396b6fa0d3dd708e76c1bd", "ba78997921bbcdc1373bb41e913ab953", "42fdf8~
# $ payment_sequential   <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
# $ payment_type         <chr> "credit_card", "credit_card", "credit_card", "credit_card", "credit_card", "credit_card", "credit_card", "credit_card", "credit_card", "boleto", "credi~
# $ payment_installments <dbl> 8, 1, 1, 8, 2, 2, 1, 3, 6, 1, 8, 1, 1, 5, 4, 10, 1, 1, 4, 3, 4, 2, 4, 10, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 2, 8, 1, 1, 1, 1, 1, 5, 5, 4,~
# $ payment_value        <dbl> 99.33, 24.39, 65.71, 107.78, 128.45, 96.12, 81.16, 51.84, 341.09, 51.95, 188.73, 141.90, 75.78, 102.66, 105.28, 157.45, 132.04, 98.94, 244.15, 136.71, ~
all_tables[['order_payments']]%>%glimpse()


summary(all_tables[['order_payments']])


all_tables[['order_payments']]%>%
  dplyr::filter(payment_installments > 1)%>%
  group_by(order_id,payment_installments)%>%
  summarise(n = n())%>%
  ungroup(.)%>%
  dplyr::filter(n>1)

all_tables[['order_payments']]%>%
  dplyr::filter(payment_installments > 1)%>%
  group_by(payment_installments)%>%
  summarise(n = n(),
            #
            orders = length(unique(order_id)),
            #Value of the transaction
            payment_value = mean(payment_value))

all_tables[['order_payments']]%>%
  dplyr::filter(order_id=="041f09bbcd85d178903f5bb71f11a02e")
#Not entirely clear how many rows exist for each of different orders
#Appears to be specific to the order item

all_tables[['orders']]%>%
  # dplyr::filter(order_id=="041f09bbcd85d178903f5bb71f11a02e")%>%
  inner_join(all_tables[['order_payments']])%>%
  #Not sure if this is a sound join for the tables
  #As the payment_sequential is defined as 'a customer may pay an order with more than one payment method. If he does so, a sequence will be created to' 
  inner_join(all_tables[['order_items']],by = c("payment_sequential" = "order_item_id","order_id" = "order_id"))%>%
  select(order_id,payment_sequential,product_id,price,freight_value)%>%
  group_by(order_id)%>%
  summarise(orders = length(unique(order_id)),
            products = length(unique(product_id)),
            n = n())%>%
  dplyr::filter(n > 1)%>%arrange(desc(n))

all_tables[['order_payments']]%>%
  group_by(payment_installments)%>%
  summarise(across(everything(),mean))
