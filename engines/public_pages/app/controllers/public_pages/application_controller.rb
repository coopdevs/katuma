module PublicPages
  class ApplicationController < ::ApplicationController

    private

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
