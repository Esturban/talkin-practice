# orders

all_tables[['orders']]%>%glimpse()


#Rows: 99,441
# Columns: 8
# $ order_id                      <chr> "e481f51cbdc54678b7cc49136f2d6af7", "53cdb2fc8bc7dce0b6741e2150273451", "47770eb9100c2d0c44946d9cf07ec65d", "949d5b44dbf5de918fe9c16f~
# $ customer_id                   <chr> "9ef432eb6251297304e76186b10a928d", "b0830fb4747a6c6d20dea0b8c802d7ef", "41ce2a54c0b03bf3443c3d931a367089", "f88197465ea7920adcdbec73~
# $ order_status                  <chr> "delivered", "delivered", "delivered", "delivered", "delivered", "delivered", "invoiced", "delivered", "delivered", "delivered", "del~
# $ order_purchase_timestamp      <dttm> 2017-10-02 10:56:33, 2018-07-24 20:41:37, 2018-08-08 08:38:49, 2017-11-18 19:28:06, 2018-02-13 21:18:39, 2017-07-09 21:57:05, 2017-0~
# $ order_approved_at             <dttm> 2017-10-02 11:07:15, 2018-07-26 03:24:27, 2018-08-08 08:55:23, 2017-11-18 19:45:59, 2018-02-13 22:20:29, 2017-07-09 22:10:13, 2017-0~
# $ order_delivered_carrier_date  <dttm> 2017-10-04 19:55:00, 2018-07-26 14:31:00, 2018-08-08 13:50:00, 2017-11-22 13:39:59, 2018-02-14 19:46:34, 2017-07-11 14:58:04, NA, 20~
# $ order_delivered_customer_date <dttm> 2017-10-10 21:25:13, 2018-08-07 15:27:45, 2018-08-17 18:06:29, 2017-12-02 00:28:42, 2018-02-16 18:17:02, 2017-07-26 10:57:55, NA, 20~
# $ order_estimated_delivery_date <dttm> 2017-10-18, 2018-08-13, 2018-09-04, 2017-12-15, 2018-02-26, 2017-08-01, 2017-05-09, 2017-06-07, 2017-03-06, 2017-08-23, 2017-06-07, ~
#Orders were completed between October 2016 to October 2018
#2 years of data
summary(all_tables[['orders']])

#Customer ID identified as the identifier to match
#Orders and customer table is the same length

all_tables[['customers']]%>%
  #Gather a sample of 100 customers
  dplyr::sample_n(1000)%>%
  # dplyr::sample_frac(1/994)%>%
  inner_join(all_tables[['orders']])%>%
  group_by(customer_unique_id)%>%
  summarise(n = n(),
            multiple = sum(ifelse(n > 1,1,0)))%>%
  arrange(desc(n))

#Determine how many customers by region have purchased more than once  
all_tables[['customers']]%>%
  #Gather a sample of 100 customers
  # dplyr::sample_n(1000)%>%
  # dplyr::sample_frac(1/994)%>%
  inner_join(all_tables[['orders']])%>%
  #Features by customer and their orders
  group_by(customer_unique_id)%>%
  #Identify the number of orders by client
  mutate(orders = n())%>%
  #By city, determine the number of customers
  group_by(customer_city)%>%
  summarise(customers = length(unique(customer_unique_id)),
            repeat_customers = length(unique(customer_unique_id[orders > 1])),
            orders = n(),
            outstanding = length(unique(order_id[is.na(order_delivered_carrier_date)])),
            pct_repeat = scales::percent(repeat_customers/customers))%>%
  # arrange(desc(repeat_customers/customers))
  arrange(desc(outstanding))

require(ggplot2)
all_tables[['orders']]%>%
  timetk::tk_augment_timeseries_signature(.date_var = "order_purchase_timestamp")%>%
  mutate(date = as.Date(order_purchase_timestamp))%>%
  group_by(date)%>%
  summarise(n = n())%>%
  ggplot2::ggplot(aes(x = date, y = n)) + geom_line()


#November of 2017 saw the largest influx of clients making 
#purchases on the website
all_tables[['orders']]%>%
  timetk::tk_augment_timeseries_signature(.date_var = "order_purchase_timestamp")%>%
  mutate(date = as.Date(order_purchase_timestamp))%>%
  group_by(date)%>%
  # Equivalent:
  # summarise(n = length(unique(order_id)))%>%
  summarise(n = n())%>%
  arrange(desc(n))

#Too few observations in 2016
#Appears that most clients complete their purchases on Mondays in 
# 2017 and 2018
all_tables[['orders']]%>%
  timetk::tk_augment_timeseries_signature(.date_var = "order_purchase_timestamp")%>%
  group_by(year,wday.lbl)%>%
  summarise(n =n())%>%
  group_by(year)%>%
  mutate(pct = n/sum(n))%>%
  arrange(desc(n))%>%
  ungroup(.)%>%
  print(n = 100)



#Find the average number of days it took to deliver an order from the purchase time, by city 
all_tables[['customers']]%>%
  inner_join(all_tables[['orders']])%>%
  dplyr::filter(!is.na(order_purchase_timestamp))%>%
  mutate(time_to_deliver = as.numeric(difftime(time2 = order_purchase_timestamp,time1 = order_delivered_customer_date, units = "days")))%>%
  group_by(customer_city)%>%
  summarise(n = n(),
            delivery_days = mean(time_to_deliver),)%>%
  dplyr::filter(n>1)%>%
  dplyr::top_n(n = 100, wt = 1/delivery_days)%>%
  arrange(delivery_days)


#Determine the time for approval after a purchase is completed by the customer, by city
all_tables[['customers']]%>%
  inner_join(all_tables[['orders']])%>%
  #~ removing close to 3000 rows for completeness of data by region
  dplyr::filter(!is.na(order_purchase_timestamp), !is.na(order_delivered_customer_date))%>%
  mutate(time_to_approve = as.numeric(difftime(time2 = order_purchase_timestamp,time1 = order_approved_at, units = "mins")))%>%
  group_by(customer_city)%>%
  summarise(n = n(),
            approval_mins = mean(time_to_approve),)%>%
  dplyr::filter(n>1)%>%
  #Find the top 100 fastest approval regions when approving for clients
  dplyr::top_n(n = 100, wt = 1/approval_mins)%>%
  arrange(desc(approval_mins))



#Determine the time for approval after a purchase is completed by the customer, by city
#The majority of states observe an F distribution in their density plot
#Indicating that there are mostly edge cases that drive up the mean
all_tables[['customers']]%>%
  inner_join(all_tables[['orders']])%>%
  #~ removing close to 3000 rows for completeness of data by region
  dplyr::filter(!is.na(order_purchase_timestamp), !is.na(order_delivered_customer_date))%>%
  mutate(time_to_approve = as.numeric(difftime(time2 = order_purchase_timestamp,time1 = order_approved_at, units = "mins")))%>%
  group_by(customer_city,customer_state)%>%
  summarise(n = n(),
            approval_mins = mean(time_to_approve),)%>%
  ggplot(aes(x = approval_mins, fill = customer_state)) + 
  # geom_histogram(bins = 100) + 
  geom_density() + 
  facet_wrap(~customer_state)
