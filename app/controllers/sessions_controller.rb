class SessionsController < ApplicationController
  layout 'plane'

  def new
  end

  def create
    @user = login("#{params[:company_uid]}/#{params[:login_name]}", params[:password])
    if @user.is_a? Administrator || @user.company.uid != params[:company_uid]
      head :not_found
      logout
      return
    end
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to 'sessions/sign_in'
  end
end
