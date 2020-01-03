class ApiController < ActionController::Base
  include ApiParamsConverter

  # check_authorization
  # TODO auth validatio 

  before_action :set_current_user
  skip_before_action :verify_authenticity_token

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
    end
  end


  private

  def render_json_resources(resources)
    render json: (params[:count].presence ?  {data: resources, count: resources.total_count} : resources)
  end

  def not_authenticated
    head 404
  end

  def set_current_user
    Current.user = current_user
  end

  def not_authenticated
    head :unauthorized
  end

  def require_token
    access_token = request.headers['Authorization']&.gsub(/\AToken\s+/, '')
    user = User.find_by_access_token(access_token)
    unless user
      head :unauthorized
      return
    end
    auto_login(user)
  end

  def api_require_login
    # 一時的に無効
    #require_token
  end

  class << self
    def api_authorize_resource
      # 一時的に無効
      #authorize_resource
    end
  end
end
