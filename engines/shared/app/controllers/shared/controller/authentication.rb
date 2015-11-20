module Shared
  module Controller
    module Authentication

      extend ::ActiveSupport::Concern

      included do
        helper_method :current_user
      end

      protected

      def current_user
        katuma_header = request.headers['HTTP_X_KATUMA_USER_ID']
        return @_current_user if defined?(@_current_user)
        return if katuma_header.blank?

        @_current_user = nil
        namespace = self.class.name.split('::').first
        klass     = "#{namespace}::User".constantize rescue nil
        klass   ||= Shared::User::Stub

        @_current_user = klass.find_by_id(katuma_header)
      end

      # Checks if the request comes from a logged in user
      #
      def authenticate
        head :unauthorized unless current_user
      end
    end
  end
end
