module AutonomieProject
  include TagUtil
  def autonomieproject(baseurl, company_id)
    #doc = open("http://www.autonomieproject.com/all.html") { |f| Hpricot(f) }
    doc = Nokogiri::HTML(open("http://www.autonomieproject.com/all.html"))

#    <table width="500" border=0 cellpadding=6 cellspacing=0>
#      <tr><td colspan=3>^M<br>^M<!-- REMOVED BREAKS PRECEDING PROD LIST^M<br>^M<br>^M-->^M</td></tr>
#      <tr>
#        <td bgcolor="" align="left" valign="top">^M<!-- ORIGINAL PROD IMAGE LINK PRIOR TO SEO LINK INSERTION <a href="http://www.autonomieproject.com/mm5/merchant.mvc?Screen=PROD&Store_Code=AP&Product_Code=601&Category_Code=all"><img src="graphics/00000001/601-THM.gif" border=0></a>^M-->^M<a href="/601-fair_trade-all.html^M"><img src="graphics/00000001/601-THM.gif" border=0></a>^M</td><td colspan=2 align="left" valign="top" nowrap bgcolor="">
#        <font face="Arial, Helvetica" size="-1" color="#5A471C">
#          <a href="/601-fair_trade-all.html">Ethletic Flip Flop (Adult)</a><br>^MCode: <b>601</b><br>^M<!-- STANDARD PRICE DISPLAY PRIOR TO DYNAMIC DISCOUNT PRICING^MPrice: <b>$22.00</b><br> -->^MPrice: <b>$22.00</b><br> Quantity in Basket:^M<i>none</i>^M<br>^M</font>

    @product_list = ProductList.new
    begin
      table = doc.xpath("//table")[9]
      table.xpath("tr/td").each do |data|
        begin
          name = data.xpath("font/a").inner_html
          if name.chomp == ""
            next
          end

          link = baseurl + data.xpath("font").search('a').attr('href').to_s

          # I don't see mm5 in the source but somehow it is getting appended to the image path!
          image = baseurl + "/mm5/" + data.previous.xpath("a/img").attr('src').to_s

          price = nil
          (data/"font").search("b").each do |value|
              # There are other text within bold. Look for only $ text
              price = value.inner_html if value.inner_html.include? "$"
          end
          price.gsub!('$','').to_f

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
            @product_list.add(product)
            tag_product(product)
          else
            logger.error "Invalid product " + name
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
