class Task < ApplicationRecord
  FIELDS = [:deadline, :done, :name, :position].freeze

  belongs_to :project, inverse_of: :tasks
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  scope :ordered, -> { order(position: :asc) }

  acts_as_list scope: :project
end
