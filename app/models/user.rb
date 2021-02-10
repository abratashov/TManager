class User < ApplicationRecord
  include DeviseTokenAuthenticatable

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects
  has_many :comments, through: :tasks

  validates :username,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-zA-Z0-9]*\z/ }
end
