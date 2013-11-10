class ApplicationController < ActionController::API
  # waiting for https://github.com/rails-api/rails-api/issues/81
  include ActionController::StrongParameters
end
