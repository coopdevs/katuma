module Account
  class ApplicationController < ActionController::Base
    helper Shared::ApplicationHelper

    include Shared::Controller::Layout
    include Shared::Controller::Manifests
    include Shared::Controller::Authentication
  end
end
