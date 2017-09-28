module Api::V1
  class ProjectsController < ApiController
    load_and_authorize_resource

    def index
      @projects = current_user.projects

      render json: @projects
    end

    def show
      render json: @project
    end

    def create
      @project = current_user.projects.new(project_params)

      if @project.save
        render json: @project, status: :created, location: @project
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    def update
      if @project.update(project_params)
        render json: @project
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @project.destroy
    end

    private

      # Only allow a trusted parameter "white list" through.
      def project_params
        params.require(:project).permit(:name)
      end
  end
end
