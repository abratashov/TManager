module Api::V1
  class ProjectsController < ApiController
    load_and_authorize_resource through: :current_user

    def index
      jsonapi_render json: current_user.projects
    end

    def show
      jsonapi_render json: @project
    end

    def create
      project = current_user.projects.new(resource_params)

      if project.save
        jsonapi_render json: project, status: :created
      else
        jsonapi_render_errors json: project, status: :unprocessable_entity
      end
    end

    def update
      if @project.update(resource_params)
        jsonapi_render json: @project
      else
        jsonapi_render_errors json: @project, status: :unprocessable_entity
      end
    end

    def destroy
      @project.destroy
    end
  end
end
