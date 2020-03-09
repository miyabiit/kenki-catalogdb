class Api::TextPropsController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @text_props
  end

  def show
    render json: @text_prop
  end

  def create
    @text_prop = TextProp.new(form_params)
    @text_prop.save!
    render json: @text_prop
  end

  def update
    @text_prop.update_attributes!(form_params)
    render json: @text_prop
  end

  def destroy
    @text_prop.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, TextProp.form_attribute_names)
  end

  def search_params
    params.permit(text_prop: TextProp.search_attribute_names)
  end

  def fetch_resources
    @text_props = TextProp.accessible_by(current_ability).search(params[:text_prop]).pagination_by_params(params)
  end

  def fetch_resource
    @text_prop = TextProp.accessible_by(current_ability).find(params[:id])
  end
end
