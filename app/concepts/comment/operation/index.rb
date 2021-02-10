module Comment::Operation
  class Index < Base::Operation::Base
    step :model
    step Policy::Pundit(CommentPolicy, :index?)

    def model(ctx, current_user:, resource_params:, params:, **)
      task = scope(user: current_user, res: Task).find(params[:task_id])
      ctx[:model] = task.comments
    end
  end
end
