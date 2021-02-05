module Api
  module V1
    class ProjectsController < ApiController
      def index
        result = run Project::Operation::Index do
          return render json: Project::Representer::Index.new(@model)
        end
        render_error(result['result.notify'])
      end

      def show
        result = run Project::Operation::Show do
          return render json: Project::Representer::Show.new(@model)
        end

        render_error(result['result.notify'])
      end

      def create
        result = run Project::Operation::Create do
          return render json: Project::Representer::Show.new(@model), status: :created
        end

        render_error(result['result.notify'])
      end

      def update
        result = run Project::Operation::Update do
          return render json: Project::Representer::Show.new(@model)
        end

        render_error(result['result.notify'])
      end

      def destroy
        result = run Project::Operation::Destroy do
          return render json: Project::Representer::Show.new(@model), status: :no_content
        end

        render_error(result['result.notify'])
      end
    end
  end
end
