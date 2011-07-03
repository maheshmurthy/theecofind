class ScraperController < ApplicationController
  before_filter :require_admin
  path = "#{RAILS_ROOT}/lib/scrapers/*.rb"
  Dir[path].each {|file| include self.class.const_get(File.basename(file).gsub('.rb','').gsub('_',' ').titleize.gsub(' ','').to_s) }
  def scrape_all
    companies = Company.all
    companies.each do |company|
    end
  end

  def scrape
    @company = Company.find_by_name(params[:id])
    @product_list = self.send(@company.name, @company.website, @company.id)
  end
end
