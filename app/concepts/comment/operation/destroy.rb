module Comment::Operation
  class Destroy < Base::Operation::Base
    step :model!
    step Policy::Pundit(CommentPolicy, :destroy?)
    step :destroy!

    def model!(ctx, current_user:, resource_params:, params:, **)
      ctx[:model] = scope(user: current_user, res: Comment).find(params[:id])
    end

    def destroy!(ctx, **)
      ctx[:model].destroy!
    end
  end
end
