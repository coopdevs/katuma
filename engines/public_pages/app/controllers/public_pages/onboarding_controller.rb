module PublicPages
  class OnboardingController < PublicPages::ApplicationController

    before_action :redirect_if_logged_in

    def signup
    end

    def create_user
      user = User.new(users_params)
      if user.save
        session[:current_user_id] = user.id

        redirect_to '/app/#/dashboard' # TODO put this in some config
      else
        flash[:error] = "Something went wrong :("
        render 'signup'
      end
    end

    private

    def users_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
