class Api::TokensController < ApiController
  def create
    @user = login(params[:login_name], params[:password])
    if @user.is_a? Administrator || @user.company.uid != params[:company_uid]
      head :not_found
      return
    end
    @access_token = @user.generate_token
    render json: {token: @access_token}
  end
end
