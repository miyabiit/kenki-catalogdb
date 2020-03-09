class Api::FilePropsController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @file_props
  end

  def show
    render json: @file_prop
  end

  def create
    @file_prop = FileProp.new(form_params)
    @file_prop.save!
    render json: @file_prop
  end

  def update
    @file_prop.update_attributes!(form_params)
    render json: @file_prop
  end

  def destroy
    @file_prop.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, FileProp.form_attribute_names)
  end

  def search_params
    params.permit(file_prop: FileProp.search_attribute_names)
  end

  def fetch_resources
    @file_props = FileProp.accessible_by(current_ability).search(params[:file_prop]).pagination_by_params(params)
  end

  def fetch_resource
    @file_prop = FileProp.accessible_by(current_ability).find(params[:id])
  end
end
