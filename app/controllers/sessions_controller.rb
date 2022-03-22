class SessionsController < ApplicationController
  def create
    user = User.find_by!(email: parmas[:email])
    user.authenticate(params[:password])

    if user.authenticate(params[:password])
      render json: user.authenticate_token
    else
      head :unauthorized
    end
  end
end
