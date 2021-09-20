# geolocation


# Rows: 1,000,163
# Columns: 5
# $ geolocation_zip_code_prefix <chr> "01037", "01046", "01046", "01041", "01035", "01012", "01047", "01013", "01029", "01011", "01013", "01032", "01014", "~
# $ geolocation_lat             <dbl> -23.54562, -23.54608, -23.54613, -23.54439, -23.54158, -23.54776, -23.54627, -23.54692, -23.54377, -23.54764, -23.5473~
# $ geolocation_lng             <dbl> -46.63929, -46.64482, -46.64295, -46.63950, -46.64161, -46.63536, -46.64123, -46.63426, -46.63428, -46.63603, -46.6341~
# $ geolocation_city            <chr> "sao paulo", "sao paulo", "sao paulo", "sao paulo", "sao paulo", "são paulo", "sao paulo", "sao paulo", "sao paulo", "~
# $ geolocation_state           <chr> "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP", "SP"~
all_tables[['geolocation']]%>%glimpse()

summary(all_tables[['geolocation']])


all_tables[['geolocation']]%>%
  group_by(geolocation_state)%>%
  summarise(n = n())%>%
  arrange(desc(n))

