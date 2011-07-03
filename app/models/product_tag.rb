class ProductTag < ActiveRecord::Base
  cattr_reader :per_page
  belongs_to :product
  belongs_to :tag
end
