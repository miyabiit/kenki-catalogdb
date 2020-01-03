class Api::ProductsController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @products
  end

  def show
    render json: @product
  end

  def create
    @product = Product.new(form_params)
    @product.save!
    render json: @product
  end

  def update
    @product.update_attributes!(form_params)
    render json: @product
  end

  def destroy
    @product.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, Product.form_attribute_names)
  end

  def search_params
    params.permit(product: Product.search_attribute_names)
  end

  def fetch_resources
    @products = Product.accessible_by(current_ability).search(search_params[:product]).pagination_by_params(params)
  end

  def fetch_resource
    @product = Product.accessible_by(current_ability).find(params[:id])
  end
end
