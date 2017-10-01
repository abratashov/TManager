class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_error_response
  rescue_from StandardError, with: :render_error_response

  def render_not_found_response
    render json: { message: 'Not found', code: 'not_found' }, status: :not_found
  end

  # :nocov:
  def render_error_response(exception)
    render json: { message: exception.message, code: 'Error' }, status: :internal_server_error
  end
  # :nocov:
end
