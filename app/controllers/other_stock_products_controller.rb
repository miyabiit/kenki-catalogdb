class OtherStockProductsController < ApplicationController
  before_action :require_login
  authorize_resource :stock_product, parent: false

  before_action :fetch_parent
  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    @stock_product = StockProduct.new(search_params[:stock_product])
  end

  def show
  end

  private

  def search_params
    params.permit(stock_product: StockProduct.search_attribute_names)
  end

  def fetch_resources
    @stock_products = StockProduct.joins(:product).includes(:product).where.not(company_id: current_user.company_id).where(stock_product_id: nil)
    if params[:product_code_or_title].present?
      @stock_products = @stock_products.product_code_or_title(params[:product_code_or_title])
    end
    @stock_products = @stock_products.search(search_params[:stock_product]).pagination_by_params(params)
  end

  def fetch_resource
    @stock_product = StockProduct.includes(:product).where.not(company_id: current_user.company_id).where(stock_product_id: nil).find(params[:id])
  end

  def fetch_parent
    @product = Product.accessible_by(current_ability).find(params[:product_id]) if params[:product_id].present?
  end
end
