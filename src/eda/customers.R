# customers

# Rows: 99,441
# Columns: 5
# $ customer_id              <chr> "06b8999e2fba1a1fbc88172c00ba8bc7", "18955e83d337fd6b2def6b18a428ac77", "4e7b3e00288586ebd08712fdd0374a03", "b2b6027bc5c5109e529d4dc6358b1~
# $ customer_unique_id       <chr> "861eff4711a542e4b93843c6dd7febb0", "290c77bc529b7ac935b93aa66c333dc3", "060e732b5b29e8181a18229c7b0b2b5e", "259dac757896d24d7702b9acbbff3~
# $ customer_zip_code_prefix <chr> "14409", "09790", "01151", "08775", "13056", "89254", "04534", "35182", "81560", "30575", "39400", "20231", "18682", "05704", "95110", "13~
# $ customer_city            <chr> "franca", "sao bernardo do campo", "sao paulo", "mogi das cruzes", "campinas", "jaragua do sul", "sao paulo", "timoteo", "curitiba", "belo~
# $ customer_state           <chr> "SP", "SP", "SP", "SP", "SP", "SC", "SP", "MG", "PR", "MG", "MG", "RJ", "SP", "SP", "RS", "SP", "RJ", "SP", "SP", "PA", "SC", "GO", "SP", ~
all_tables[['customers']] %>% glimpse()

#Summary of the data to determine factors and components of repetition
summary(all_tables[['customers']] %>% mutate(
  customer_id = as.factor(customer_id),
  customer_unique_id = as.factor(customer_unique_id),
  customer_city = as.factor(customer_city),
  customer_state = as.factor(customer_state),
))

#Convert the zip code prefix into a numeric value
all_tables[['customers']] %<>% mutate(customer_zip_code_prefix = as.numeric(customer_zip_code_prefix))

#See the proportion of customers who come from different regions
all_tables[['customers']] %>%
  group_by(customer_city, customer_zip_code_prefix) %>%
  summarise(
    n = n(),
    unq_cid = length(unique(customer_id)),
    unq_unq_cid = length(unique(customer_unique_id)),
    .groups = 'drop'
  ) %>% arrange(desc(n))

#1/6 customers from Sao paulo
#1/15 customers from Rio de Janeiro
all_tables[['customers']] %>%
  group_by(customer_city) %>%
  summarise(
    n = n(),
    unq_cid = length(unique(customer_id)),
    unq_unq_cid = length(unique(customer_unique_id)),
    .groups = 'drop'
  ) %>% 
  arrange(desc(n))%>%
  mutate(pct = paste0(round(n/sum(n)*100,2),"%"))



