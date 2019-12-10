class ApplicationController < ActionController::Base
  check_authorization

  before_action :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to '/sessions/sign_in', notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def not_authenticated
    redirect_to '/sessions/sign_in'
  end

  def set_current_user
    Current.user = current_user
  end
end
