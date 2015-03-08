module Doorkeeper
  module LogoutAfterAuthorize
    # From here: https://github.com/amaabca/doorkeeper-logout_redirect
    # This method is overriding doorkeeper redirect
    # to remove user from rails session when is logged
    # via Oauth2. This way users logged in with oauth
    # can logout from rails revoking access token
    # I'm not sure about this. Review with a backend ;)
    def redirect_to(options = {}, response_status = {})
      logout if matches_application_redirect_uri?(options)
      super
    end

  private

    # Katuma logout session
    def logout
      @_current_user = session[:current_user_id] = nil
    end

    def matches_application_redirect_uri?(redirect_uri)
      Doorkeeper::Application.pluck(:redirect_uri).each do |uri|
        return true if (redirect_uri =~ /^#{Regexp.escape(uri)}/) == 0
      end
      return false
    end
  end
end
