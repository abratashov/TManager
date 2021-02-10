module Task::Operation
  class Show < Base::Operation::Base
    step :model!
    step Policy::Pundit(TaskPolicy, :show?)

    def model!(ctx, current_user:, resource_params:, params:, **)
      ctx[:model] = scope(user: current_user, res: Task).find(params[:id])
    end
  end
end
