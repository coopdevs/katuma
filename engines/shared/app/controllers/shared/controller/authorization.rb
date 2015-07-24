module Shared
  module Controller
    module Authorization

      extend ::ActiveSupport::Concern

      included do
        include Pundit
        rescue_from Pundit::NotAuthorizedError, with: :forbidden_request
      end

      protected

      def forbidden_request
        redirect_to '/dashboard', alert: 'Sorry, you are not authorized. Please ask to a group admin to get more help.'
      end
    end
  end
end
