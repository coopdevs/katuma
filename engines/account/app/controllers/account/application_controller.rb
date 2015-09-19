module Account
  class ApplicationController < ActionController::Base
    include ::Shared::Controller::Authentication
  end
end
