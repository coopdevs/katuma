class ApplicationController < ActionController::API
  # waiting for https://github.com/rails-api/rails-api/issues/81
  include ActionController::StrongParameters
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      api_key = ApiKey.where(access_token: token).first
      @current_user = api_key.user if api_key
    end
  end
end
