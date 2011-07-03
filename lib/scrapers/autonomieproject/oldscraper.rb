require 'rubygems'
require 'open-uri'
require 'hpricot'

baseurl="http://www.autonomieproject.com"
#doc = open("http://www.autonomieproject.com/all.html") { |f| Hpricot(f) }
doc = open("all.html") { |f| Hpricot(f) }

(doc/"//table[3]/tr").each do |data|
  name = (data/"font/a").inner_html
  if name.chomp == ""
    next
  end

  link = baseurl + (data/"font").search('a').attr('href')

  image = baseurl + (data/"a")[0].search("img").attr('src')

  price = nil
  (data/"font").search("b").each do |value|
      price = value.inner_html if value.inner_html.include? "$"
  end
  puts name + " " + image + " " + link  + " " + price
end
