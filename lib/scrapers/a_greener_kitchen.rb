module AGreenerKitchen
  def agreenerkitchen(baseurl, company_id)
    doc = Nokogiri::HTML(open("http://agreenerkitchen.com/products-page/?items_per_page=all"))
    @product_list = ProductList.new
    begin
      doc.xpath("//div[starts-with(@class,'product_grid_item')]").each do |data|
        begin
          full_link = data.xpath(".//div['item_image']/a")
          link = full_link.attr('href').to_s
          name = (full_link/"img").attr('title').to_s
          image = (full_link/"img").attr('src').to_s
          price = data.xpath(".//div['product_text']/span").inner_html.gsub('Price: $','').to_f

          product = Product.find_by_name(name)

          if product.nil?
            product = Product.new
            product.company_id = company_id
          end

          product.name = name
          product.price = price
          product.image = image
          product.link = link

          if product.is_valid?
            product.save
            # If new product, add to the category as well.
            # This is kitchen item. For now, just add to kitchen category until I figure out a better way to do this.
            tag = Tag.find_by_name("kitchen")
            ProductTag.find_or_create_by_product_id_and_tag_id(:product_id => product.id, :tag_id => tag.id)
            @product_list.add(product)
          end
        rescue Exception => product_exception
          logger.error "Exception while scraping for product" + product_exception
        end
      end
      return @product_list
    rescue Exception => global_exception
      logger.error "Exception at global level" + global_exception
    end
  end
end
