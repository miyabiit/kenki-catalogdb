class AdminSessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:login_name], params[:password])
    unless @user.is_a? Administrator
      head :not_found
      logout
      return
    end
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to 'admin_sessions/sign_in'
  end
end
