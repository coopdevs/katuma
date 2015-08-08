module Onboarding
  class ApplicationController < ActionController::Base

    include Shared::Controller::Base
    include Shared::Controller::Layout
    include Shared::Controller::Manifests
    include Shared::Controller::Authentication
  end
end
