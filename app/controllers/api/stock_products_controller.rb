class Api::StockProductsController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @stock_products
  end

  def show
    render json: @stock_product
  end

  def create
    @stock_product = StockProduct.new(form_params)
    @stock_product.save!
    render json: @stock_product
  end

  def update
    @stock_product.update_attributes!(form_params)
    render json: @stock_product
  end

  def destroy
    @stock_product.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, StockProduct.form_attribute_names)
  end

  def search_params
    params.permit(stock_product: StockProduct.search_attribute_names)
  end

  def fetch_resources
    @stock_products = StockProduct.joins(:product).includes(:product).accessible_by(current_ability).where(stock_product_id: nil)
    if params[:product_name_or_title].present?
      @stock_products = @stock_products.product_name_or_title(params[:product_name_or_title])
    end
    @stock_products = @stock_products.search(params[:stock_product]).pagination_by_params(params)
  end

  def fetch_resource
    @stock_product = StockProduct.includes(:product).accessible_by(current_ability).where(stock_product_id: nil).find(params[:id])
  end
end
