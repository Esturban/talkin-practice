#products
all_tables[['products']]%>%
  # inner_join(all_tables[['product_category_name_translation']], by = 'product_category_name')%>%glimpse()
  inner_join(all_tables[['product_category_name_translation']], by = 'product_category_name')%>%
  group_by(product_category_name_english)%>%
  summarise(products = n(),
            avg_name_length = mean(product_name_lenght),
            avg_desc_length = mean(product_description_lenght),
            avg_num_photos = mean(product_photos_qty),
            avg_volume = mean(product_length_cm/100*product_height_cm/100*product_width_cm/100,na.rm=T)
            )%>%arrange(desc(avg_volume))%>%print(n=100)



summary(all_tables[['products']]%>%
          # inner_join(all_tables[['product_category_name_translation']], by = 'product_category_name')%>%glimpse()
          inner_join(all_tables[['product_category_name_translation']], by = 'product_category_name'))
