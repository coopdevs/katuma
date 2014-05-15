class ApplicationController < ActionController::API
  # authorization gem
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_request

  private

  def unauthorized_request
    render text: "401 Unauthorized", status: :unauthorized
  end
end
