class Api::SubCategoriesController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @sub_categories
  end

  def show
    render json: @sub_category
  end

  def create
    @sub_category = SubCategory.new(form_params)
    @sub_category.save!
    render json: @sub_category
  end

  def update
    @sub_category.update_attributes!(form_params)
    render json: @sub_category
  end

  def destroy
    @sub_category.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, SubCategory.form_attribute_names)
  end

  def search_params
    params.permit(sub_category: SubCategory.search_attribute_names)
  end

  def fetch_resources
    @sub_categories = SubCategory.accessible_by(current_ability).search(search_params[:sub_category]).pagination_by_params(params)
  end

  def fetch_resource
    @sub_category = SubCategory.accessible_by(current_ability).find(params[:id])
  end
end
