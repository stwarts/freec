module Authenticatable
  def authenticate_admin!
    current_admin_user
  end

  def current_admin_user
    @current_admin_user ||= User.admin.find_by!(password_digest: authenticate_token)
  end

  private

  def authenticate_token
    request.headers['Authorization']
  end
end
