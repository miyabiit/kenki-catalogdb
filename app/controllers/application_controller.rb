class ApplicationController < ActionController::Base
  check_authorization

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

end
