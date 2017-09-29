module Api::V1
  class CommentsController < ApplicationController
    load_and_authorize_resource :project, through: :current_user
    load_and_authorize_resource :task, through: :project
    load_and_authorize_resource :comment, through: :task

    def index
      @comments = @task.comments

      render json: @comments
    end

    def create
      @comment = @task.comments.new(comment_params)

      if @comment.save
        render json: @comment, status: :created, location: project_task_comment_url(@project, @task, @comment)
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @comment.destroy
    end

    private

      def comment_params
        params.require(:comment).permit(:body, :attachment)
      end
  end
end
