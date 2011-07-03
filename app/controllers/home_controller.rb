class HomeController < ApplicationController
  def index
    @product_map = Hash.new
    # Build a map of display_type to list of products where display type is featured product, recently added and so on
    # Get some featured products
    # We just want to display 5 for now
    @product_map["featured"] = Display.unexpired.find_all_by_display_type('FEATURED').sort_by { rand }.slice(0...5)
    # Get some recently added products
    @product_map["recent"] = Display.unexpired.find_all_by_display_type('RECENT').sort_by { rand }.slice(0...5)
  end

  def search
    begin
      @product_list = Product.search(params[:query], :order => :price, :per_page => 10, :page => params[:page], :retry_stale => true)
    rescue Exception => e
      logger.error "Search not working. Page out!"
    end
  end
end
