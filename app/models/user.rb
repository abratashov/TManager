class User < ApplicationRecord
  include DeviseTokenAuthenticatable

  has_many :projects, dependent: :destroy

  validates :username,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-zA-Z0-9]*\z/ }
end
