module Onboarding
  class ApplicationController < ActionController::Base
    include Shared::Controller::Authentication
    include Shared::Controller::Authorization
    include Shared::Controller::ParameterMissingException
  end
end
