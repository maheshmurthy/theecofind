class TagController < ApplicationController
  def products
    begin
    tag = Tag.find_by_name(params[:id])
    unless tag.nil?
      @product_tags = ProductTag.find_all_by_tag_id(tag.id)
      @product_tags = @product_tags.paginate(:per_page => 10, :page => params[:page])
    else
      @product_tags = Array.new
      @product_tags = @product_tags.paginate
    end
    rescue Exception => e
      @product_tags = Array.new
      @product_tags = @product_tags.paginate
    end
  end
end
