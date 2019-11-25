class AdminSessionsController < ApplicationController
  layout 'plane'

  def new
  end

  def create
    @user = login(params[:login_name], params[:password])
    unless @user && @user.is_a?(Administrator)
      head :not_found
      logout
      return
    end
    redirect_back_or_to(:companies, notice: 'ログインしました')
  end

  def destroy
    logout
    redirect_to 'admin_sessions/sign_in'
  end
end
