class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true
  validates :email, presence: true,
            length: {maximum: Settings.user.max_length},
            format: {with: VALID_EMAIL_REGEX}

  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
