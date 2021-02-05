module Project::Operation
  class Index < Base::Operation::Base
    step :check_user!
    fail :process_absence
    step :model
    step Policy::Pundit(ProjectPolicy, :index?)

    def check_user!(_ctx, current_user:, **)
      current_user
    end

    def model(ctx, current_user:, **)
      ctx[:model] = scope(user: current_user, res: Project)
    end

    def process_absence(ctx, current_user:, **)
      ctx['result.notify'] = 'user not present'
    end
  end
end
