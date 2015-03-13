module Account
  class SessionController < ApplicationController

    before_action :redirect_if_logged_in, only: :login

    # Renders the login view
    #
    def login
    end

    # Logs in the user
    #
    def login_attempt
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:current_user_id] = user.id
        redirect_after_login_success
      else
        flash[:error] = "Invalid Email or password"
        render :login
      end
    end

    # Logs out the user
    #
    def logout
      @_current_user = session[:current_user_id] = nil

      redirect_to '/'
    end

    private

    def redirect_after_login_success
      if session[:user_return_to]
        redirect_to session[:user_return_to]
        session[:user_return_to] = nil
      else
        redirect_to '/app/#/dashboard' # TODO put this in some config
      end
    end
  end
end
