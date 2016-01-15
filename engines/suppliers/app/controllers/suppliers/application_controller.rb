module Suppliers
  class ApplicationController < ActionController::Base
    include ::Shared::Controller::Authentication

    rescue_from 'ActiveRecord::InvalidForeignKey' do |exception|
      adapter = ExceptionAdapter.new
      render json: ::Shared::Error.new(adapter, name: :bad_request)
    end

    class ExceptionAdapter
      def errors
        'The provided id does not exist'.freeze
      end
    end
  end
end
