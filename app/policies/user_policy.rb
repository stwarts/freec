class UserPolicy
  def initialize(user)
    @user = user
  end

  def index?
    user.admin
  end

  def create?
    user.admin
  end

  def show?
    user.admin
  end

  def update?
    user.admin
  end

  def delete?
    user.admin
  end
end
