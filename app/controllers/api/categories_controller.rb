class Api::CategoriesController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(form_params)
    @category.save!
    render json: @category
  end

  def update
    @category.update_attributes!(form_params)
    render json: @category
  end

  def destroy
    @category.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, Category.form_attribute_names)
  end

  def search_params
    params.permit(category: Category.search_attribute_names)
  end

  def fetch_resources
    @categories = Category.accessible_by(current_ability).search(params[:category]).pagination_by_params(params)
  end

  def fetch_resource
    @category = Category.accessible_by(current_ability).find(params[:id])
  end
end
