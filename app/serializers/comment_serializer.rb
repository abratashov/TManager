class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :attachment
  has_one :task
end
