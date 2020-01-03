class Api::CompaniesController < ApiController
  before_action :api_require_login
  api_authorize_resource

  before_action :fetch_resource, only: [:show, :edit, :update, :destroy]
  before_action :fetch_resources, only: [:index]

  def index
    render_json_resources @companies
  end

  def show
    render json: @company
  end

  def create
    @company = Company.new(form_params)
    @company.save!
    render json: @company
  end

  def update
    @company.update_attributes!(form_params)
    render json: @company
  end

  def destroy
    @company.destroy!
    head :ok
  end

  private

  def form_params
    api_params(params, Company.form_attribute_names)
  end

  def search_params
    params.permit(company: Company.search_attribute_names)
  end

  def fetch_resources
    @companies = Company.accessible_by(current_ability).search(search_params[:company]).pagination_by_params(params)
  end

  def fetch_resource
    @company = Company.accessible_by(current_ability).find(params[:id])
  end
end
