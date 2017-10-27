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
end
