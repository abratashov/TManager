module Comment::Contract
  class Create < Reform::Form
    property :body
    property :attachment
    property :task_id

    validation name: :default do
      required(:body).filled(:str?, min_size?: 10, max_size?: 256)
      optional(:attachment)
    end
  end
end
