module TagUtil
  def TagUtil.tag_product(product)
    product_tags = ProductTypeTag.search(product.name, :match_mode => :any)
    tag_id_set = Set.new
    product_tags.each do |product_tag|
      tag_id_set.add(product_tag.tag_id)
    end
    tag_id_set.each do |tag_id|
      ProductTag.find_or_create_by_product_id_and_tag_id(:product_id => product.id, :tag_id => tag_id)
    end
  end
end
