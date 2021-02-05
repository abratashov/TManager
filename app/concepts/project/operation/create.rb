module Project::Operation
  class Create < Base::Operation::Base
    step :model
    step Policy::Pundit(ProjectPolicy, :create?)
    step Contract::Build(constant: Project::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()

    def model(ctx, current_user:, resource_params:, **)
      attrs = resource_params.slice(:name)
      ctx[:model] = scope(user: current_user, res: Project).new(attrs)
    end
  end
end
