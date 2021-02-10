class Comment < ApplicationRecord
  FIELDS = [:body, :attachment].freeze

  belongs_to :task, counter_cache: true

  delegate :project, to: :task, allow_nil: true

  validates :body, length: { minimum: 10, maximum: 256 }

  mount_uploader :attachment, AttachmentUploader
end
