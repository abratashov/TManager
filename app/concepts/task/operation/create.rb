module Task::Operation
  class Create < Base::Operation::Base
    step :model
    step Policy::Pundit(TaskPolicy, :create?)
    step Contract::Build(constant: Task::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()

    def model(ctx, current_user:, resource_params:, params:, **)
      project = scope(user: current_user, res: Project).find(params[:project_id])
      attrs = resource_params.slice(*Task::FIELDS)
      ctx[:model] = project.tasks.new(attrs)
    end
  end
end
