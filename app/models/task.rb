class Task < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  scope :ordered, -> { order(position: :asc) }

  acts_as_list scope: :project
end
