# order_reviews


# Rows: 100,000
# Columns: 7
# $ review_id               <chr> "7bc2406110b926393aa56f80a40eba40", "80e641a11e56f04c1ad469d5645fdfde", "228ce5500dc1d8e020d8d1322874b6f0", "e64fb393e7b32834bb789ff8bb30750~
# $ order_id                <chr> "73fc7af87114b39712e6da79b0a377eb", "a548910a1c6147796b98fdf73dbeba33", "f9e4b658b201a9f2ecdecbb34bed034b", "658677c97b385a9be170737859d3511~
# $ review_score            <dbl> 4, 5, 5, 5, 5, 1, 5, 5, 5, 4, 5, 5, 4, 4, 3, 5, 2, 5, 3, 1, 4, 5, 5, 5, 5, 5, 4, 5, 5, 1, 5, 5, 1, 5, 4, 5, 5, 5, 5, 1, 2, 1, 5, 5, 5, 4, 5,~
# $ review_comment_title    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, "recomendo", NA, NA, NA, NA, NA, "Super recomendo", NA, NA, NA, "Não chegou meu produto", NA, NA, "Ótimo~
# $ review_comment_message  <chr> NA, NA, NA, "Recebi bem antes do prazo estipulado.", "Parabéns lojas lannister adorei comprar pela Internet seguro e prático Parabéns a todo~
# $ review_creation_date    <dttm> 2018-01-18, 2018-03-10, 2018-02-17, 2017-04-21, 2018-03-01, 2018-04-13, 2017-07-16, 2018-08-14, 2017-05-17, 2018-05-22, 2017-12-23, 2017-12~
# $ review_answer_timestamp <dttm> 2018-01-18 21:46:59, 2018-03-11 03:05:13, 2018-02-18 14:36:24, 2017-04-21 22:02:06, 2018-03-02 10:26:53, 2018-04-16 00:39:37, 2017-07-18 19~
all_tables[['order_reviews']]%>%glimpse()

summary(all_tables[['order_reviews']])


#Expected review score distributions where it's skewed heavily to the good reviews
#ie (5,4,1,3,2)
all_tables[['order_reviews']]%>%
  inner_join(all_tables[['orders']])%>%
  inner_join(all_tables[['customers']])%>%
  group_by(customer_state, review_score)%>%
  summarise(n = n(),
            no_title = sum(ifelse(is.na(review_comment_title),1,0)),
            no_msg = sum(ifelse(is.na(review_comment_message),1,0)),
            no_msg_title = sum(ifelse(is.na(review_comment_message) & is.na(review_comment_title),1,0)),
            .groups = "drop")%>%
  #Overall, how did the clients from different states rate the service overall
  # ggplot(aes(x = review_score, y = n, fill = customer_state)) + geom_bar(stat = "identity") + facet_wrap(~customer_state,scales = "free_y")
  #Find out how the clients who left no title and no message felt about the service
  ggplot(aes(x = review_score, y = no_msg_title, fill = customer_state)) + geom_bar(stat = "identity") + facet_wrap(~customer_state,scales = "free_y")


#Did clients complain immediately or did they wait before leaving a bad review?  
all_tables[['order_reviews']]%>%
  inner_join(all_tables[['orders']])%>%
  inner_join(all_tables[['customers']])%>%
  #Find all of the poor review scores
  dplyr::filter(review_score==1)%>%
  #Create a category to determine missing packages
  mutate(missing = ifelse(is.na(order_delivered_customer_date),"Missing","Completed"))%>%
  #Used to determine the proportion of clients who have complaints about missing orders
  #or orders that do not have a delivery date
  # group_by(missing)%>%
  dplyr::filter(missing == "Completed")%>%
  group_by(customer_state)%>%
  #Find the reviews and orders that were missing the order
  summarise(reviews = length(unique(review_id)),
            orders = length(unique(order_id)),
            no_title = sum(ifelse(is.na(review_comment_title),1,0)),
            no_msg = sum(ifelse(is.na(review_comment_message),1,0)),
            no_msg_title = sum(ifelse(is.na(review_comment_message) & is.na(review_comment_title),1,0)),
            days_until_delivery = mean(as.numeric(difftime(time2 = review_creation_date, time1 = order_delivered_customer_date, units = "days" ))), 
            days_to_complaint = mean(as.numeric(difftime(time1 = review_creation_date, time2 = order_purchase_timestamp, units = "days" ))), 
            .groups = "drop")%>%
  #To find that ~20% of complaints are coming from the missing orders
  mutate(pct = orders/sum(orders))
  #On average, complaints were made within 3.5 days
  #The results vary drastically between different customer regions and 
  # average days waiting before a complaint is made is around 20 - 30 days, depending on the region
  #
  # It appears that their may be an issue with logistics due to the nature of the e-commerce business
  # Where ~ 10% of clients are waiting almost 3 weeks to receive their product and often leave the complaint
  #before the product is received

#Below shows a distribution of the processing status of complaints.
#Appears most of them have been delivered, but the above presents an interesting avenue to create a hypothesis
#around logistics being an issue and determining how problematic this is for the business.

#
#Further investigating needed to determine whether it's the company as a whole or individual sellers
all_tables[['order_reviews']]%>%
  inner_join(all_tables[['orders']])%>%
  inner_join(all_tables[['customers']])%>%
  mutate(missing = ifelse(is.na(order_delivered_customer_date),"Missing","Completed"))%>%
#Find all of the poor review scores
dplyr::filter(review_score==1,missing == "Completed")%>%
  group_by(order_status)%>%
  summarise(n = n())
