module Account
  class SignupController < ApplicationController

    before_action :redirect_if_logged_in

    # Renders sign up form
    #
    def new
    end

    # Creates a sign up and renders check email view
    #
    # TODO: check if a User already exists with the given email
    #
    def create
      @signup = SignupService.new(signup_params[:email]).execute

      render :email_sent
    end

    # Renders the complete sign up form
    #
    def complete
      @signup = Signup.find_by_id(complete_signup_params[:id])

      unless @signup &&
        @signup.email == complete_signup_params[:email] &&
        @signup.token == complete_signup_params[:token]

        render :something_went_wrong
      end
    end

    # Renders the complete sign up form
    # when the email has been already confirmed before
    #
    def complete_from_confirmed_email
      if complete_from_confirmed_email_params[:confirmed_email]
        render :complete
      else
        render :something_went_wrong
      end
    end

    # Maybe this should go in Account::UsersController
    #
    def create_user
      user = User.new(params_for_user_creation)
      if user.save
        session[:current_user_id] = user.id

        redirect_to '/app/#/dashboard' # TODO put this in some config
      else
        redirect_to controller: :signup, action: :complete, email: user_params[:email], token: user_params[:token]
      end
    end

    private

    def signup_params
      params.permit(:email)
    end

    def complete_signup_params
      params.permit(:id, :email, :token)
    end

    def complete_from_confirmed_email_params
      params.permit(:confirmed_email)
    end

    def user_params
      params.permit(:id, :name, :password, :password_confirmation, :email, :token)
    end

    def params_for_user_creation
      user_params.slice(:id, :email, :name, :password, :password_confirmation)
    end
  end
end
