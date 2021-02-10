module Api
  module V1
    class CommentsController < ApiController
      def index
        result = run Comment::Operation::Index do
          return render json: Comment::Representer::Index.new(@model)
        end

        render_error(result['result.notify'])
      end

      def create
        result = run Comment::Operation::Create do
          return render json: Comment::Representer::Show.new(@model), status: :created
        end

        render_error(result['result.notify'])
      end

      def destroy
        result = run Comment::Operation::Destroy do
          return render json: Comment::Representer::Show.new(@model), status: :no_content
        end

        render_error(result['result.notify'])
      end
    end
  end
end
