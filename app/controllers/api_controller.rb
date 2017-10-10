class ApiController < ApplicationController
  before_action :authenticate_user!

  include JSONAPI::Utils

  rescue_from StandardError, with: :render_error_response

  def render_error_response(exception)
    render json: { message: exception.message, code: 'Error' }, status: :internal_server_error
  end
end
