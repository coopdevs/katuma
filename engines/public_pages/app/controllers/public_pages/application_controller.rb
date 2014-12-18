module PublicPages
  class ApplicationController < ActionController::Base

    private

    def current_user
      @_current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
    end

    # Redirects to private single page app if the user
    # is already logged in
    #
    def redirect_if_logged_in
      if current_user
        redirect_to '/app/#/dashboard'
      end
    end
  end
end
