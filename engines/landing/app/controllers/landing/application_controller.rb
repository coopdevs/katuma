module Landing
  class ApplicationController < ActionController::Base

    include Shared::Controller::Base
    include Shared::Controller::Authentication
    layout 'shared/layouts/base'
  end
end
