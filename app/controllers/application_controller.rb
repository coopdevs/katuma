class ApplicationController < ActionController::Base
  # authorization gem
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_request

  private

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  # Checks if the request comes from
  # a logged in user
  def authenticate
    unauthorized_request unless current_user
  end

  def unauthorized_request
    render text: "401 Unauthorized", status: :unauthorized
  end
end