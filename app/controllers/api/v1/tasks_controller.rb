module Api
  module V1
    class TasksController < ApiController
      load_and_authorize_resource :project, through: :current_user
      load_and_authorize_resource :task, through: :project

      def index
        jsonapi_render json: @project.tasks.ordered.includes(:project)
      end

      def show
        jsonapi_render json: @task
      end

      def create
        task = @project.tasks.new(resource_params)

        if task.save
          jsonapi_render json: task, status: :created
        else
          jsonapi_render_errors json: task, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(resource_params)
          jsonapi_render json: @task
        else
          jsonapi_render_errors json: @task, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
      end
    end
  end
end
