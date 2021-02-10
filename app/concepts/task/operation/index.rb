module Task::Operation
  class Index < Base::Operation::Base
    step :model
    step Policy::Pundit(TaskPolicy, :index?)

    def model(ctx, current_user:, resource_params:, params:, **)
      project = scope(user: current_user, res: Project).find(params[:project_id])
      ctx[:model] = project.tasks.ordered
    end
  end
end
