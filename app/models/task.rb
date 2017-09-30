class Task < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  acts_as_list scope: :project

  def update_position(new_position)
    insert_at(new_position) if position != new_position
  end
end
