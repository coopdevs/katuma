module Suppliers
  class ApplicationController < ActionController::Base
    include ::Shared::Controller::Authentication
  end
end
