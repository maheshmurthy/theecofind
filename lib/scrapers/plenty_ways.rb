module PlentyWays
  include TagUtil
  def plentyways(baseurl, company_id)
    @product_list = ProductList.new
    begin
      path = "#{RAILS_ROOT}/data/plentyways_product_feed_jun_2010.csv"
      file = File.new(path, "r")
      temp_image = ""
      temp_price = ""
      while (line = file.gets)
        begin
          # There are some entries who don't have image because it is same as previous product except with
          # some size difference. To workaround this, keep a temporary image and if there is no image for 
          # a next product, use this image. It can so easily screw things up. So, to mitigate that, 
          # also match the price
          row = line.split(':')
          name = row[4].gsub('"','')
          image = "http://www.plentyways.com/media/catalog/product/" + row[8].gsub('"','')
          link = baseurl + "/" + row[9].gsub('"','')
          price = row[10]
          unless row[6].empty?
            temp_image = image 
            temp_price = price
          else
            if temp_price == price
              image = temp_image
            end
          end

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
            tag_product(product)
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
