class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: true,
            length: {maximum: 500},
            format: {with: VALID_EMAIL_REGEX}
  validates :password, length: {minimum: 6}

  before_save :downcase_email

  has_secure_password
  private

  def downcase_email
    email.downcase!
  end
end
