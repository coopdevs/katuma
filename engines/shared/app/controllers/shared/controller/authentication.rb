module Shared
  module Controller
    module Authentication

      extend ::ActiveSupport::Concern

      included do
        helper_method :redirect_if_logged_in
        helper_method :current_user
      end

      protected

      def current_user
        return @_current_user if defined?(@_current_user)
        return nil unless session[:current_user_id]

        @_current_user = nil
        namespace = self.class.name.split('::').first
        klass     = "#{namespace}::User".constantize rescue nil
        klass   ||= Shared::User::Stub

        @_current_user = klass.find_by_id(session[:current_user_id])
      end

      # Checks if the request comes from a logged in user
      #
      def authenticate
        redirect_to '/logout' unless current_user
      end

      # Checks if the request comes from a logged in user
      #
      # TODO: move to API authentication module
      #
      def api_authenticate
        unless current_user
          render text: "401 Unauthorized", status: :unauthorized
        end
      end

      # Redirects to root page if the user is already logged in
      #
      def redirect_if_logged_in
        redirect_to '/dashboard' if current_user
      end
    end
  end
end
