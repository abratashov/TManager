class Project < ApplicationRecord
  FIELDS = [:deadline, :done, :name, :position].freeze

  belongs_to :user
  has_many :tasks, dependent: :destroy, inverse_of: :project
  validates :name, presence: true, uniqueness: true
end
