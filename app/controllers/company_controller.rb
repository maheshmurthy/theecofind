class CompanyController < ApplicationController
  def index
    company = Company.find_by_name(params[:id])
    @product_list = company.products.paginate(:per_page => 10, :page => params[:page])
  end
end
