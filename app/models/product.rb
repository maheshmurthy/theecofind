class Product < ActiveRecord::Base
  cattr_reader :per_page
  belongs_to :company
  define_index do
    indexes :name
    indexes price, :sortable => true
  end

  def is_valid?
    return is_url_valid?(self.link) &&
       is_url_valid?(self.image.gsub(' ', '%20')) &&
       self.price > 0
  end

  def is_url_valid?(url)
    uri = URI.parse(url)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.head(uri.path)
    end
    unless response.is_a?(Net::HTTPSuccess)
      logger.error "Broken url " + url  + ". Received response " + response.inspect
      return false
    end
    return true
  end
end
