module Project::Operation
  class Update < Base::Operation::Base
    step :model!
    step Policy::Pundit(ProjectPolicy, :update?)
    pass :assign_attributes
    step Contract::Build(constant: Project::Contract::Create)
    step Contract::Validate()
    step Contract::Persist()

    def model!(ctx, current_user:, resource_params:, params:, **)
      ctx[:model] = scope(user: current_user, res: Project).find(params[:id])
    end

    def assign_attributes(ctx, current_user:, resource_params:, **)
      attrs = resource_params.slice(:name)
      ctx[:model].assign_attributes(attrs)
    end
  end
end
