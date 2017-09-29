class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :deadline, :position, :done, :comments_count
  has_one :project
end
