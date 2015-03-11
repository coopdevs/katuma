module Shared
  module Controller
    module Authentication

      extend ::ActiveSupport::Concern

      included do
        # TODO: Move Pundit stuff to Authorization module
        include Pundit # authorization gem
        rescue_from Pundit::NotAuthorizedError, with: :forbidden_request

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

      # Checks if the request comes from
      # a logged in user
      def authenticate
        unless current_user
          render text: "401 Unauthorized", status: :unauthorized
        end
      end

      def forbidden_request
        render text: "403 Forbidden", status: :forbidden
      end

      # Redirects to private single page app if the user
      # is already logged in
      #
      def redirect_if_logged_in
        if current_user
          redirect_to '/app/#/dashboard' # TODO put this in some config
        end
      end
    end
  end
end
