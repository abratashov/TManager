class ApiController < ApplicationController
  before_action :authenticate_user!

  include JSONAPI::Utils

  rescue_from StandardError, with: :render_error_response

  def render_error_response(exception)
    error = {
      title: exception.message,
      code: 'Error',
      status: 500
    }
    render json: { errors: [error] }, status: :internal_server_error
  end

  private

  def render_error(msg = nil)
    message = msg.presence || @form&.errors&.messages
    render json: { errors: message }, status: :unprocessable_entity
  end

  def _run_options(ctx)
    raise Pundit::NotAuthorizedError unless current_user.present?

    begin
      # Bug with fetching the 'resource_params' of 'jsonapi-utils' library
      # https://github.com/tiagopog/jsonapi-utils/issues/80
      res_params = resource_params || {}
    rescue
      res_params = {}
    end

    ctx.merge(current_user: current_user, resource_params: res_params)
  end
end
