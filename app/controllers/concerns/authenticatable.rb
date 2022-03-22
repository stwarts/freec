module Authenticatable
  def authenticate_user!
    current_user
  end

  def current_user
    @current_user ||= User.find_by!(password_digest: authenticate_token)
  end

  private

  def authenticate_token
    request.headers['Authorization']
  end
end
