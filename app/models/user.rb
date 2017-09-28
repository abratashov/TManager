class User < ApplicationRecord
  # Include default devise modules.
  devise  :database_authenticatable, :registerable,
          :validatable, #:rememberable, :trackable,
          :omniauthable, authentication_keys: [:username]

  validate :password_validation

  before_validation :devise_email_skipping, on: :create

  validates :username,
            presence: true,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-zA-Z0-9]*\z/ }

  include DeviseTokenAuth::Concerns::User

  has_many :projects

  private

  def devise_email_skipping
    self.email = "#{SecureRandom.hex}@m.cc" unless email
  end

  def password_validation
    if password && !password.match(/\A[a-zA-Z\d]{8}\z/)
      errors.add(:password, "Length should be 8 characters, alphanumeric.")
    end
  end
end
