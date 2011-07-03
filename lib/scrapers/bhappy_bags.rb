require 'open-uri'

module BhappyBags 
  def bhappybags(baseurl, company_id)
    doc = Nokogiri::HTML(open(baseurl))
    @product_list = ProductList.new
    begin
      doc.xpath("//body/div['container']/div['content']/p/a").each do |link|
        products_link = link.attr('href')
        unless products_link.include? "html"
          next
        end
        products_page = baseurl + products_link
        puts products_page
        product_page_doc = Nokogiri::HTML(open(products_page))
        product_page_doc.xpath("//ul[@class='productsThumbs']/li/a[1]").each do |product_link|
        begin
          p_link = product_link.attr('href')
          name = product_link.attr('title')
          image = product_link.xpath("./img").attr('src').to_s
          product = Nokogiri::HTML(open(p_link))
          price = product.xpath("//form[@name='orderform']/h2").inner_html.to_s.gsub('$','').to_f

          product = Product.find_by_name(name)

          if product.nil?
            product = Product.new
            product.company_id = company_id
          end

          product.name = name
          product.price = price
          product.image = image
          product.link = p_link

          if product.is_valid?
            product.save
            # If new product, add to the category as well.
            # This is bag item. For now, just add to bags category until I figure out a better way to do this.
            tag = Tag.find_by_name("bags")
            ProductTag.find_or_create_by_product_id_and_tag_id(:product_id => product.id, :tag_id => tag.id)
            @product_list.add(product)
          end
        rescue Exception => product_exception
          logger.error "Exception while scraping for product" + product_exception
        end
        end
      end 
      return @product_list
    rescue Exception => global_exception
     logger.error "Exception at global level" + global_exception
    end
  end
end
