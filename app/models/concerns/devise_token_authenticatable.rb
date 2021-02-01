module DeviseTokenAuthenticatable
  extend ActiveSupport::Concern

  included do
    extend Devise::Models

    devise  :database_authenticatable, :registerable,
            :validatable, #:rememberable, :trackable,
            :omniauthable, authentication_keys: [:username]

    include DeviseTokenAuth::Concerns::User

    before_validation :devise_email_skipping, on: :create
    validate :password_validation
  end

  private

    def devise_email_skipping
      self.email = "#{SecureRandom.hex}@m.cc" unless email
    end

    def password_validation
      errors.add(:password, I18n.t('devise.passwords.format_valiation')) if invalid_password?
    end

    def invalid_password?
      password && !password.match(/\A[a-zA-Z\d]{8}\z/)
    end
end
