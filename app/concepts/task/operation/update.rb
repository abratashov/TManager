module Task::Operation
  class Update < Base::Operation::Base
    step :model!
    step Policy::Pundit(TaskPolicy, :update?)
    pass :assign_attributes
    step Contract::Build(constant: Task::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()

    def model!(ctx, current_user:, resource_params:, params:, **)
      ctx[:model] = scope(user: current_user, res: Task).find(params[:id])
    end

    def assign_attributes(ctx, current_user:, resource_params:, **)
      attrs = resource_params.slice(*Task::FIELDS)
      ctx[:model].assign_attributes(attrs)
    end
  end
end
