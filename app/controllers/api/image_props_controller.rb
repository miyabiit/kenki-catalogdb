class Api::ImagePropsController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @image_props
  end

  def show
    render json: @image_prop
  end

  def create
    @image_prop = ImageProp.new(form_params)
    @image_prop.save!
    render json: @image_prop
  end

  def update
    @image_prop.update_attributes!(form_params)
    render json: @image_prop
  end

  def destroy
    @image_prop.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, ImageProp.form_attribute_names)
  end

  def search_params
    params.permit(image_prop: ImageProp.search_attribute_names)
  end

  def fetch_resources
    @image_props = ImageProp.accessible_by(current_ability).search(params[:image_prop]).pagination_by_params(params)
  end

  def fetch_resource
    @image_prop = ImageProp.accessible_by(current_ability).find(params[:id])
  end
end
