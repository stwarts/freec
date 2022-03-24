class UserPolicy
  def initialize(user, record = nil)
    @user = user
    @record = record
  end

  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin?
  end

  def update?
    user.admin? && record&.user?
  end

  def delete?
    user.admin? && record&.user?
  end
end
