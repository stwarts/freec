class User < ApplicationRecord
  enum :user_type, { admin: 'admin', user: 'user' }

  DEFAULT_TYPE = user_types.fetch(:user)

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :user_type, presence: true

  before_validation :set_user_type

  scope :search, ->(string) {
    return all if string.blank?

    where('email ILIKE :term OR name ILIKE :term', term: "%#{string}%")
  }

  def authenticate_token
    # simple enough, can change to jwt token if needed
    password_digest
  end

  private

  def set_user_type
    self.user_type = DEFAULT_TYPE
  end
end
