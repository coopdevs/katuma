module Landing
  class ApplicationController < ActionController::Base

    include Shared::Controller::Authentication
    include Shared::Controller::Base
    layout 'shared/layouts/base'
  end
end
