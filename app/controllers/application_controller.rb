class ApplicationController < ActionController::Base
  # authorization gem
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :forbidden_request

  private

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  # Checks if the request comes from
  # a logged in user
  def authenticate
    unless current_user do
      render text: "401 Unauthorized", status: :unauthorized
    end
  end

  def forbidden_request
    render text: "403 Forbidden", status: :forbidden
  end
end
