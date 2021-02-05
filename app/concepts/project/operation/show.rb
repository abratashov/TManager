module Project::Operation
  class Show < Base::Operation::Base
    step :model!
    step Policy::Pundit(ProjectPolicy, :show?)

    def model!(ctx, current_user:, resource_params:, params:, **)
      ctx[:model] = scope(user: current_user, res: Project).find(params[:id])
    end
  end
end
