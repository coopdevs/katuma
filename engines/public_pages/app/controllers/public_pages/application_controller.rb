module PublicPages
  class ApplicationController < ActionController::Base

    private

    # Retrieves the user session and, if any, checks if it's a valid one
    #
    def current_user
      @_current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
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
