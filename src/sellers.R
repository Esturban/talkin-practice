#sellers

# Rows: 3,095
# Columns: 4
# $ seller_id              <chr> "3442f8959a84dea7ee197c632cb2df15", "d1b65fc7debc3361ea86b5f14c68d2e2", "ce3ad9de960102d0677a81f5d0bb7b2d", "c0f3eea2e14555~
# $ seller_zip_code_prefix <chr> "13023", "13844", "20031", "04195", "12914", "20920", "55325", "16304", "01529", "80310", "75110", "13530", "01222", "05372~
# $ seller_city            <chr> "campinas", "mogi guacu", "rio de janeiro", "sao paulo", "braganca paulista", "rio de janeiro", "brejao", "penapolis", "sao~
# $ seller_state           <chr> "SP", "SP", "RJ", "SP", "SP", "RJ", "PE", "SP", "SP", "PR", "GO", "SP", "SP", "SP", "SC", "BA", "SC", "DF", "BA", "SP", "SP~
all_tables[['sellers']]%>%glimpse()

summary(all_tables[['sellers']])

all_tables[['sellers']]%>%
  group_by(seller_city)%>%
  summarise(n = n())%>%arrange(desc(n))


#Appears to be a city that is named as a phone number or something.  Probably just dirty data or an online business
