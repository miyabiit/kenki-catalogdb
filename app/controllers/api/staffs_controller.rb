class Api::StaffsController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @staffs
  end

  def show
    render json: @staff
  end

  def create
    @staff = Staff.new(form_params)
    @staff.save!
    render json: @staff
  end

  def update
    @staff.update_attributes!(form_params)
    render json: @staff
  end

  def destroy
    @staff.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, Staff.form_attribute_names)
  end

  def search_params
    params.permit(staff: Staff.search_attribute_names)
  end

  def fetch_resources
    @staffs = Staff.accessible_by(current_ability).search(search_params[:staff]).pagination_by_params(params)
  end

  def fetch_resource
    @staff = Staff.accessible_by(current_ability).find(params[:id])
  end
end
