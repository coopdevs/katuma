require 'pundit'

module Shared
  module Controller
    module Authorization

      extend ::ActiveSupport::Concern

      included do
        include ::Pundit
        rescue_from ::Pundit::NotAuthorizedError, with: :forbidden_response
      end

      protected

      def forbidden_response
        head :forbidden
      end
    end
  end
end
