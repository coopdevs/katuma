module Shared
  module Controller
    module Authentication

      extend ::ActiveSupport::Concern

      included do
        helper_method :current_user
      end

      protected

      def current_user
        return @_current_user if defined?(@_current_user)
        return unless request.env['HTTP_X_KATUMA_USER_ID']

        @_current_user = nil
        namespace = self.class.name.split('::').first
        klass     = "#{namespace}::User".constantize rescue nil
        klass   ||= Shared::User::Stub

        @_current_user = klass.find_by_id(request.env['HTTP_X_KATUMA_USER_ID'])
      end

      # Checks if the request comes from a logged in user
      #
      def authenticate
        render nothing: true, status: :unauthorized unless current_user
      end
    end
  end
end
