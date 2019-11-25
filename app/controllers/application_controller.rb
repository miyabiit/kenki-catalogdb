class ApplicationController < ActionController::Base

  private

  def not_authenticated
    redirect_to '/admin_sessions/sign_in'
  end
end
