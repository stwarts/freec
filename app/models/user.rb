class User < ApplicationRecord
  enum :user_type, { admin: 'admin', user: 'user' }

  DEFAULT_TYPE = user_types.fetch(:user)

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :user_type, presence: true

  before_validation :set_user_type

  private

  def set_user_type
    self.user_type = DEFAULT_TYPE
  end
end
