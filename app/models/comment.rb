class Comment < ApplicationRecord
  belongs_to :task, counter_cache: true

  validates :body, length: { minimum: 10, maximum: 256 }

  mount_uploader :attachment, AttachmentUploader
end
