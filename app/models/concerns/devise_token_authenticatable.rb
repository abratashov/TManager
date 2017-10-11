module DeviseTokenAuthenticatable
  extend ActiveSupport::Concern

  included do
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
    if password && !password.match(/\A[a-zA-Z\d]{8}\z/)
      errors.add(:password, I18n.t('devise.passwords.format_valiation'))
    end
  end
end
