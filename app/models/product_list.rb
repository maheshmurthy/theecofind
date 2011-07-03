class ProductList
  attr_accessor :products
  cattr_reader :per_page

  def initialize
    @products = Array.new
  end

  def add(product)
    @products << product
  end
end
