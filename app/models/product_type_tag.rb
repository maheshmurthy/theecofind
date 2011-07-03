class ProductTypeTag < ActiveRecord::Base
  belongs_to :tag
  define_index do
    indexes :product_type
  end
end
