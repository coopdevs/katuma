module Group
  class ApplicationController < ActionController::Base
    include Shared::Controller::Authentication
    include Shared::Controller::Authorization
  end
end
