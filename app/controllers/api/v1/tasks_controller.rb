module Api
  module V1
    class TasksController < ApiController
      def index
        result = run Task::Operation::Index do
          return render json: Task::Representer::Index.new(@model)
        end

        render_error(result['result.notify'])
      end

      def show
        result = run Task::Operation::Show do
          return render json: Task::Representer::Show.new(@model)
        end

        render_error(result['result.notify'])
      end

      def create
        result = run Task::Operation::Create do
          return render json: Task::Representer::Show.new(@model), status: :created
        end

        render_error(result['result.notify'])
      end

      def update
        result = run Task::Operation::Update do
          return render json: Task::Representer::Show.new(@model)
        end

        render_error(result['result.notify'])
      end

      def destroy
        result = run Task::Operation::Destroy do
          return render json: Task::Representer::Show.new(@model), status: :no_content
        end

        render_error(result['result.notify'])
      end
    end
  end
end
