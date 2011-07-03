require 'open-uri'

module E3Living
  include TagUtil
  def e3living(baseurl, company_id)
    doc = Nokogiri::HTML(open(baseurl + "/sitemap"))
    products = Array.new
    begin
      doc.xpath("//div[@class='site-map']/div[@class='box'][4]//div[@class='tree']/ul/li/a").each do |data|
        link = data.attr('href').gsub('taxonomy/term','catalog')
        products << get_products(baseurl, link, company_id)
        product_list_doc = Nokogiri::HTML(open(baseurl + link))
        product_list_doc.xpath("//div[@class='pager']/span[@class='pager-list']/a").each do |page_link|
            products << get_products(baseurl, page_link.attr('href'), company_id)
        end
      end
      products.flatten!
      logger.info "Total products for e3living: " + products.length.to_s
      @product_list = ProductList.new
      products.each do |product|
      begin
        if product.is_valid?
          # if product does not have an id, this is a new product
          product.save
          tag_product(product)
         @product_list.add(product)
        else
          logger.error "Invalid product " + product.inspect
        end
      rescue Exception => e
        logger.error "Failed while validating product " + product.inspect + " " + e.inspect
        logger.error e.backtrace
      end
      end
    rescue Exception => global_exception
      logger.error "Exception at global level " + global_exception.inspect
        logger.error global_exception.backtrace
    end
    return @product_list
  end

  def get_products(baseurl, page_link, company_id)
    begin
      product_list_doc = Nokogiri::HTML(open(baseurl + page_link))
      puts page_link
      products = Array.new
      product_list_doc.xpath("//div[@class='category-grid-products']/table/tr/td").each do |product_doc|
        a_tag = product_doc.xpath(".//span[@class='catalog_grid_title']/a")

        name = a_tag.inner_html

        product = Product.find_by_name(name)

        if product.nil?
          product = Product.new
          product.company_id = company_id
        end

        product.name = name
        product.link = baseurl + a_tag.attr('href')

        image = product_doc.xpath(".//span[@class='catalog_grid_image']/a/img")
        if image.length > 0
          product.image = product_doc.xpath(".//span[@class='catalog_grid_image']/a/img").attr('src').to_s
        else
          product.image = "/images/no_image.gif"
        end
        product.price = product_doc.xpath(".//span[@class='catalog_grid_sell_price']").inner_html.to_s.gsub('$','')
        products << product
      end
    rescue Exception => product_exception
      logger.error "Exception in get_products for link " + page_link + " " + product_exception.inspect
      logger.error product_exception.backtrace
    end
    return products
  end
end
