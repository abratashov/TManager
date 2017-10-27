module Api
  module V1
    class CommentsController < ApiController
      load_and_authorize_resource :project, through: :current_user
      load_and_authorize_resource :task, through: :project
      load_and_authorize_resource :comment, through: :task

      def index
        jsonapi_render json: @task.comments
      end

      def create
        comment = @task.comments.new(resource_params)

        if comment.save
          jsonapi_render json: comment, status: :created
        else
          jsonapi_render_errors json: comment, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
      end
    end
  end
end
