module Api::V1
  class TasksController < ApiController
    load_and_authorize_resource :project
    load_and_authorize_resource :task, through: :project

    def index
      @tasks = @project.tasks

      render json: @tasks
    end

    def show
      render json: @task
    end

    def create
      @task = @project.tasks.new(task_params)

      if @task.save
        render json: @task, status: :created, location: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        render json: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @task.destroy
    end

    private

      def task_params
        params.require(:task).permit(:name, :deadline, :position, :done)
      end
  end
end
