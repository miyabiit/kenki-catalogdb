class ApplicationController < ActionController::Base

  private

  def not_authenticated
    redirect_to '/sessions/sign_in'
  end
end
