module Onboarding
  class ApplicationController < ActionController::Base
    include ::Shared::Controller::Authentication
  end
end
