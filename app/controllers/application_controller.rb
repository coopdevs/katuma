class ApplicationController < ActionController::API
  # waiting for https://github.com/rails-api/rails-api/issues/81
  include ActionController::StrongParameters
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # authorization gem
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_request
  after_filter :set_access_control_headers

  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Request-Method'] = '*' 
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      api_key = ApiKey.where(access_token: token).first
      @current_user = api_key.user if api_key
    end
  end

  def current_user
    @current_user
  end

  private

  def unauthorized_request
    render text: "401 Unauthorized", status: :unauthorized
  end
end
