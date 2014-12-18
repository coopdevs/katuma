module PublicPages
  class SessionController < ApplicationController

    before_action :redirect_if_logged_in, only: :login

    def login
    end

    def login_attempt
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:current_user_id] = user.id
        redirect_to '/app/#/dashboard'
      else
        render 'login'
      end
    end

    def logout
      @_current_user = session[:current_user_id] = nil

      redirect_to :root
    end
  end
end
