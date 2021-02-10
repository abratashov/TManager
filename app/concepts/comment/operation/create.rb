module Comment::Operation
  class Create < Base::Operation::Base
    step :model
    step Policy::Pundit(CommentPolicy, :create?)
    step Contract::Build(constant: Comment::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()

    def model(ctx, current_user:, resource_params:, params:, **)
      task = scope(user: current_user, res: Task).find(params[:task_id])
      attrs = resource_params.slice(*Comment::FIELDS)
      ctx[:model] = task.comments.new(attrs)
    end
  end
end
