class ApplicationController < ActionController::API
  include Trailblazer::Rails::Controller
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
end
